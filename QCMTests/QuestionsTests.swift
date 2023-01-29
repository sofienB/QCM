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
            XCTAssertFalse(questions?.questions.isEmpty ?? false)
            loadingExp?.fulfill()
        }
    }
    
    func testExample() throws {
        loadingExp = expectation(description: "Loading pets")
        questions?.loadQuestions()
        
        // wait 10 seconds
        wait(for: [loadingExp!], timeout: 10)
    }
}
