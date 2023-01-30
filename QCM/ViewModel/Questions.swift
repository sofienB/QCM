//
//  Questions.swift
//  QCM
//
//  Created by Sofien Benharchache on 28/01/2023.
//

import Foundation

class Questions {
    // MARK: - Private properties
    
    private var questions = [Question]()
    private var iterator: Int = 0

    private var answers = [Answer]() {
        didSet { iterator += 1 }
    }
    
    private var state: LoadingState = .idle {
        didSet { self.delegate?.didUpdate(state: state) }
    }
    
    // MARK: - Public properties
    public weak var delegate: QuestionsProtocol?

    public var total: Int { get { questions.count } }
    
    public var index: Int { get { iterator } }
    
    public var isFinished: Bool {
        iterator >= questions.count && answers.count == questions.count && !questions.isEmpty
    }
    
    public var nextQuestion: Question? {
        isFinished || iterator == questions.count ? nil : questions[iterator]
    }
    
    // MARK: - Public methods
    func loadQuestions() {
        self.state = .loading

        // Result traitment
        let loadingResult: GenericResult<[Question]> = { [weak self] response in
            self?.answers.removeAll()
            self?.iterator = 0

            switch response {
            case .success(let result):
                self?.questions = result
                self?.questions.sort()
                self?.state = .success
            case .failure(let error):
                self?.questions = []
                self?.state = .error(error)
            }
        }
        
        Networking.load(from: "data", completion: loadingResult)
    }
    
    // return true if answer is conform to multi-answer.
    func check(answer: Answer) -> Bool {
        guard let question = nextQuestion, question.id == answer.id
        else { return false }
        
        guard answer.choices.contains(where: { answerChoice in
            question.choices.contains(where: { answerChoice == $0.id })
        })
        else { return false }
        
        return question.multiple && answer.choices.count > 1
            || !question.multiple && answer.choices.count == 1
    }
    
    // return true if answer is added, else return false.
    func add(answer currentAnswer: Answer) -> Bool {
        guard check(answer: currentAnswer)
        else { return false }
        
        answers.append(currentAnswer)
        
        return true
    }
    
    func answerToJson() -> Data? {
        return answers.toJson()
    }
    
    func toString() -> String? {
        return answerToJson()?.toString()
    }
}


// MARK: - DEBUG : only used by Unit tests !
    
#if DEBUG

extension Questions {
    func add(questions: [Question]) {
        self.questions = questions
    }
    
    var questionsSetted: [Question] {
        get { questions }
    }
}

#endif
