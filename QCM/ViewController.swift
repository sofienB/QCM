//
//  ViewController.swift
//  QCM
//
//  Created by Sofien Benharchache on 27/01/2023.
//

import UIKit

final class ViewController: UIViewController {

    private var questions = Questions()
    private var spinner = SpinnerView()
    
    private var titleLbl: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        return label
    }()

    private var questionView = QuestionView()
    private lazy var nextButton: UIButton = {
        let button = UIButton(configuration: .bordered())
        button.backgroundColor = .QCMBlue.withAlphaComponent(0.3)
        button.addTarget(self, action: #selector(self.nextAction), for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.tintColor = .label
        button.isEnabled = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()

        spinner.parentView = self.view

        questions.delegate = self
        questions.loadQuestions()
        
        questionView.delegate = self
    }
    
    private func configureView() {
        self.view.addSubview(titleLbl)
        self.view.addSubview(questionView)
        self.view.addSubview(nextButton)
        
        updateNextButton(title: NSLocalizedString("next", comment: "next"))
        configureConstraint()
        updateView()
    }
    
    private func configureConstraint() {
        // Title
        titleLbl.centerX(inView: self.view,
                         topAnchor: self.view.safeAreaLayoutGuide.topAnchor,
                         paddingTop: 40)
        
        titleLbl.anchor(leading: self.view.safeAreaLayoutGuide.leadingAnchor,
                        trailing: self.view.safeAreaLayoutGuide.trailingAnchor,
                        paddingBottom: 18, paddingRight: 18)

        // Question
        questionView.center(inView: self.view)
        questionView.anchor(
            top: titleLbl.bottomAnchor,
            leading: self.view.safeAreaLayoutGuide.leadingAnchor,
            trailing: self.view.safeAreaLayoutGuide.trailingAnchor,
            paddingLeft:18, paddingRight: 18)
        
        // Button
        nextButton.anchor(bottom: self.view.safeAreaLayoutGuide.bottomAnchor,
                          leading: self.view.safeAreaLayoutGuide.leadingAnchor,
                          trailing: self.view.safeAreaLayoutGuide.trailingAnchor,
                          paddingBottom: 18, paddingRight: 18, height: 45)
    }

    // used to load answers when QCM is finished.
    private func presentResult() {
        guard let htmlContent = questions.answerToJson()?.toString()
        else { return }
        
        let htmlBody = """
            <html> <body style="background-color:#483d8b">
            <pre> <code style="zoom: 2.5; color:#FFFFFF;font-size:20px;">
            \(htmlContent)
            </code> </pre> </body> </html>
            """
        let webViewController = WebViewController()
        webViewController.load(answer: htmlBody)
        self.present(webViewController, animated: true)
    }
    
    private func updateNextButton(title: String) {
        let font = UIFont(name: "HelveticaNeue-Bold", size: 23)
        let attributedText = NSAttributedString(string: title,
                                                attributes: [NSAttributedString.Key.font: font!])
        self.nextButton.setAttributedTitle(attributedText, for: .normal)
    }
    
    private func updateView() {
        if questions.isFinished {
            questionView.removeFromSuperview()
            titleLbl.text = "🎉 " + NSLocalizedString("congratulation", comment: "Congratulation") + " 🎉"
            updateNextButton(title:NSLocalizedString("show result", comment: "Show result"))
            presentResult()
            return
        }
        
        guard let question = questions.nextQuestion
        else { return }
        
        self.title = "QCM \(questions.index + 1)/\(questions.total)"
        titleLbl.text = question.name
        questionView.update(question: question)
        
        // Update Next Button.
        var isValid = false
        if let answer = questionView.answer() {
            isValid = questions.check(answer: answer)
        }
        nextButton.isEnabled = isValid
    }

    @objc func nextAction() {
        guard let answers = questionView.answer()
        else { return }
        
        guard questions.check(answer: answers)
        else { updateView(); return }
        
        guard questions.add(answer: answers)
        else { return }
        
        updateView()
    }
}

extension ViewController: QuestionsProtocol {
    func didUpdate(state: LoadingState) {
        switch state {
        case .idle: break
        case .loading: // show loading view.
            spinner.show()
        case .success:
            handleSuccess()
        case .error(let error):
            self.handle(error: error as? NetworkingError)
        }
    }
}

// MARK: - Networking handler.
extension ViewController {

    func handleSuccess() {
        self.spinner.dismiss()
        self.updateView()
    }
    
    /// Handle error
    ///
    /// - Parameter error: handled
    func handle(error: NetworkingError?) {
        switch error {
        case .request(error: _): showAlertError(message: NSLocalizedString("request", comment:""))
        case .timedOut: showAlertError(message: NSLocalizedString("timedOut", comment:""))
        case .invalidUrl: showAlertError(message: NSLocalizedString("invalidUrl", comment:""))
        case .dataNotFound: showAlertError(message: NSLocalizedString("decodedError", comment:""))
        case .decoded(error: _): showAlertError(message: NSLocalizedString("error", comment:""))
        case .unknown(error: _): showAlertError()
        case .none: showAlertError()
        }
    }
    
    func showAlertError(message: String? = nil) {
        let alertTitle = NSLocalizedString("Alert", comment:"")
        let alertMessage = message == nil
            ? NSLocalizedString("anErrorOccured", comment:"An error occured")
            : message

        let alertCtrl = UIAlertController(title: alertTitle,
                                        message: alertMessage,
                                        preferredStyle: .alert)
        
        let okButton = NSLocalizedString("OK", comment:"")
        alertCtrl.addAction(UIAlertAction(title: okButton, style: .default))

        self.present(alertCtrl, animated: true, completion: nil)
    }
}

extension ViewController: QuestionViewProtocol {
    func didUpdate(answer: Answer) {
        // nextButton is enabled if answer is valid
        nextButton.isEnabled = questions.check(answer: answer)
    }
    
    func show(information: String) {
        let viewC = UIViewController()
        viewC.view.backgroundColor = .darkslateblue
        
        let titleLbl = UILabel()
        titleLbl.text = NSLocalizedString("information", comment: "Information")
        titleLbl.font = .systemFont(ofSize: 35, weight: .semibold)
        titleLbl.textColor = .label

        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.text = information
        textView.font = .systemFont(ofSize: 25, weight: .semibold)
        textView.textColor = .label
        textView.backgroundColor = .darkslateblue
        
        viewC.view.addSubview(titleLbl)
        viewC.view.addSubview(textView)
        
        titleLbl.centerX(inView: viewC.view)

        titleLbl.anchor(top: viewC.view.topAnchor,
                        leading: viewC.view.leadingAnchor,
                        trailing: viewC.view.trailingAnchor,
                        paddingTop: 16,
                        paddingLeft: 16,
                        paddingRight: 16)
        
        textView.anchor(top: titleLbl.bottomAnchor,
                        bottom: viewC.view.bottomAnchor,
                        leading: viewC.view.leadingAnchor,
                        trailing: viewC.view.trailingAnchor,
                        paddingTop: 16,
                        paddingLeft: 16,
                        paddingRight: 16)

        present(viewC, animated: true)
    }
}
