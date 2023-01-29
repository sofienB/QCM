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
}
