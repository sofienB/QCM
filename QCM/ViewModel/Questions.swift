//
//  Questions.swift
//  QCM
//
//  Created by Sofien Benharchache on 28/01/2023.
//

import Foundation

class Questions {
    // Properties
    private var questions = [Question]()
    private var iterator: Int = 0

    private var answers = [Answer](){
        didSet {
            iterator += 1
        }
    }
    
    private var state: LoadingState = .idle {
        didSet {
            self.delegate?.didUpdate(state: state)
        }
    }
    public var delegate: QuestionsProtocol?
 
    // Public methods
    func loadQuestions() {
        self.state = .loading

        // Result traitment
        let loadingResult: GenericResult<[Question]> = { [weak self] response in
            self?.answers.removeAll()
            self?.iterator = 0

            switch response {
            case .success(let result):
                self?.questions = result
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
        
        return false
    }
    
    // return true if answer is added, else return false.
    func add(answer currentAnswer: Answer) -> Bool {
        answers.append(currentAnswer)
        
        return false
    }
    
    var isFinished: Bool {
        get {
            return iterator >= questions.count
        }
    }
    
    func nextQuestion() -> Question? {
        return isFinished ? nil : questions[iterator]
    }
}

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
