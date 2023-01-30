//
//  QuestionsTests.swift
//  QCMTests
//
//  Created by Sofien Benharchache on 29/01/2023.
//

import XCTest
@testable import QCM

final class QuestionsTests: XCTestCase, QuestionsProtocol {
    var questions: Questions?
    var loadingExp: XCTestExpectation? = nil
    
    let question_1 = Question(id: 007,
                           name: "Question pour un champion",
                           order: 02,
                           choices: [
                             Choice(id: 01, name: "A",
                                    description: nil),
                             Choice(id: 02, name: "B",
                                    description: nil),
                             Choice(id: 03, name: "C",
                                    description: nil)
                           ],
                           question: "Où est la reponse 'D' ?",
                           multiple: false)
    
    let question_2 = Question(id: 009,
                           name: "Question pour un champion",
                           order: 02,
                           choices: [
                             Choice(id: 01, name: "A",
                                    description: nil),
                             Choice(id: 02, name: "B",
                                    description: nil),
                             Choice(id: 03, name: "C",
                                    description: nil)
                           ],
                           question: "Où est la reponse 'D' ?",
                           multiple: true)
 
    
    override func setUp() async throws {
        questions = Questions()
        questions?.delegate = self
    }

    func didUpdate(state: LoadingState) {
        if state != .idle && state != .loading && state != .success {
            XCTFail("State is not passed: state == \(state)")
        }
        if state == .success {
            XCTAssertFalse(questions?.questionsSetted.isEmpty ?? false)
            loadingExp?.fulfill()
        }
    }
    
    func testLoadingData() throws {
        loadingExp = expectation(description: "Loading pets")
        questions?.loadQuestions()
        
        // wait 10 seconds
        wait(for: [loadingExp!], timeout: 10)
    }
    
    func testSortQuestions() throws {
    
        // Data
        let question_1 = Question(id: 007,
                                  name: "Question pour un champion",
                                  order: 03,
                                  choices: [Choice(id: 01, name: "A", description: nil)],
                                  question: "",
                                  multiple: true)
        
        let question_2 = Question(id: 008,
                                  name: "Question pour un champignon",
                                  order: 01,
                                  choices: [Choice(id: 01, name: "A", description: nil)],
                                  question: "",
                                  multiple: true)
        
        let question_3 = Question(id: 009,
                                  name: "Question pour les nuls",
                                  order: 02,
                                  choices: [Choice(id: 01, name: "A", description: nil)],
                                  question: "",
                                  multiple: true)
        
        // Mock data
        questions?.add(questions: [question_1, question_2, question_3])
        
        // Data sets in specific order
        XCTAssertEqual(questions?.questionsSetted[0].order, 03)
        XCTAssertEqual(questions?.questionsSetted[1].order, 01)
        XCTAssertEqual(questions?.questionsSetted[2].order, 02)
        
        // Do Sort
        var didSort = questions?.questionsSetted
        didSort?.sort()

        // Check sorted data.
        if let didSort {
            XCTAssertEqual(didSort[0].order, 01)
            XCTAssertEqual(didSort[0].name, "Question pour un champignon")
            
            XCTAssertEqual(didSort[2].order, 03)
            XCTAssertEqual(didSort[2].name, "Question pour un champion")

            XCTAssertEqual(didSort[1].order, 02)
            XCTAssertEqual(didSort[1].name, "Question pour les nuls")
        } else {
            XCTFail("questions should not be nil")
        }
    }
    
    func testCheckAnswer() throws {
        guard let questions = questions
        else {
            XCTFail("questions should not be nil")
            return
        }
        
        questions.add(questions: [question_2])

        // Good Answer
        let answer = Answer(id: 009, choices: [02, 03])
        XCTAssertTrue(questions.check(answer: answer))
        
        // Bad Answer : Bad Id
        let badIdAnswer = Answer(id: 042, choices: [02, 03])
        XCTAssertFalse(questions.check(answer: badIdAnswer))
        
        // Bad Answer : Bad multi choice.
        let badChoicesAnswer = Answer(id: 009, choices: [02])
        XCTAssertFalse(questions.check(answer: badChoicesAnswer))
        
        // Bad Answer : empty choice.
        let EmptyChoiceAnswer = Answer(id: 009, choices: [])
        XCTAssertFalse(questions.check(answer: EmptyChoiceAnswer))
        
        // Bad Answer : same choices
        let sameChoicesAnswer = Answer(id: 009, choices: [02, 02])
        XCTAssertFalse(questions.check(answer: sameChoicesAnswer))
    }
    
    func testAddGoodAnswer() throws {
        guard let questions = self.questions
        else {
            XCTFail("questions should not be nil")
            return
        }
        
        questions.add(questions: [question_1, question_2])
        
        XCTAssertEqual(questions.iteratorState, 0)
        
        // First answer
        let answer_1 = Answer(id: 007, choices: [02])
        XCTAssertTrue(questions.check(answer: answer_1))

        let isAdded_1 = questions.add(answer: answer_1)
        XCTAssertTrue(isAdded_1)
        
        XCTAssertEqual(questions.iteratorState, 1)

        // Second answer
        let answer_2 = Answer(id: 009, choices: [01, 03])
        XCTAssertTrue(questions.check(answer: answer_2))

        let isAdded_2 = questions.add(answer: answer_2)
        XCTAssertTrue(isAdded_2)
        
        XCTAssertEqual(questions.iteratorState, 2)
    }
    
    func testAdBaddAnswer() throws {
        guard let questions = self.questions
        else {
            XCTFail("questions should not be nil")
            return
        }
        
        questions.add(questions: [question_1, question_2])
        
        // First answer
        let answer_1 = Answer(id: 007, choices: [02])
        XCTAssertTrue(questions.check(answer: answer_1))

        let isAdded_1 = questions.add(answer: answer_1)
        XCTAssertTrue(isAdded_1)
        
        // Second answer
        let answer_2 = Answer(id: 009, choices: [01, 03])
        XCTAssertTrue(questions.check(answer: answer_2))

        let isAdded_2 = questions.add(answer: answer_2)
        XCTAssertTrue(isAdded_2)
        
        // Third answer // Answer of not existing question.
        let answer_3 = Answer(id: 009, choices: [01])
        XCTAssertFalse(questions.check(answer: answer_3))

        let isAdded_3 = questions.add(answer: answer_3)
        XCTAssertFalse(isAdded_3)
    }
    
    func testJsonAnswer() throws {
        guard let questions = self.questions
        else {
            XCTFail("questions should not be nil")
            return
        }
        
        questions.add(questions: [question_1, question_2])
        
        // First answer
        let answer_1 = Answer(id: 007, choices: [02])
        let isAdded_1 = questions.add(answer: answer_1)
        
        // Second answer
        let answer_2 = Answer(id: 009, choices: [01, 03])
        let isAdded_2 = questions.add(answer: answer_2)

        // Answer added
        XCTAssertTrue(isAdded_1)
        XCTAssertTrue(isAdded_2)
        
        // To Json
        guard let jsonData = questions.answerToJson()
        else {
            XCTFail("Answers should not be nil")
            return
        }
        
        // To String
        guard let jsonString = jsonData.toString()
        else {
            XCTFail("json should not be nil")
            return
        }
        
        // Should be equals
        XCTAssertEqual(jsonString,
                       "[{\"id\":7,\"choices\":[2]},{\"id\":9,\"choices\":[1,3]}]")
    }
}
