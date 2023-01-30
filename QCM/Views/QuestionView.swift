//
//  QuestionView.swift
//  QCM
//
//  Created by Sofien Benharchache on 29/01/2023.
//

import UIKit

final class QuestionView: UIView {

    var delegate: QuestionViewProtocol?
    
    private var question: Question? {
        didSet {
            choiceLbls.forEach{ $0.removeFromSuperview() }
            choiceLbls.removeAll()
            
            for choice in question?.choices ?? [] {
                let choiceLabel = ChoiceView(choice: choice)
                choiceLabel.anchor(height: 70)
                choiceLabel.delegate = self
                choiceLbls.append(choiceLabel)
                container.addArrangedSubview(choiceLabel)
            }
        }
    }

    private var choiceLbls = [ChoiceView]()

    private lazy var questionLbl: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 23, weight: .semibold)
        return label
    }()
    
    private lazy var container: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6.0
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    init() {
        super.init(frame: .zero)

        self.addSubview(questionLbl)
        self.addSubview(container)
        questionLbl.anchor(top: topAnchor,
                           leading: leadingAnchor,
                           trailing: trailingAnchor,
                           height: 70)
        container.anchor(top: questionLbl.bottomAnchor,
                         bottom: bottomAnchor,
                         leading: leadingAnchor,
                         trailing: trailingAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(question: Question) {
        self.question = question
        questionLbl.text = question.question
    }
    
    func answer() -> Answer? {
        let selection = Set<UInt>(choiceLbls.compactMap {
            if $0.isSelected { return $0.choiceId }
            return nil
        })

        let anwer = Answer(id: question?.id, choices: selection)
        return anwer
    }
}

protocol ChoiceViewProtocol {
    func didUpdate(state: Bool)
    func show(information: String)

}

protocol QuestionViewProtocol {
    func didUpdate(answer: Answer)
    func show(information: String)
}

extension QuestionView: ChoiceViewProtocol {
    func didUpdate(state: Bool) {
        if let answer = answer() {
            delegate?.didUpdate(answer: answer)
        }
    }
    
    func show(information: String) {
        delegate?.show(information: information)
    }
}
