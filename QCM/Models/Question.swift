//
//  Question.swift
//  QCM
//
//  Created by Sofien Benharchache on 27/01/2023.
//

import Foundation

struct Question {
    let id: UInt!
    let name: String!
    let order: UInt8!
    let choices: [Choice]!
    let question: String!
    let multiple: Bool!
}

extension Question: Decodable { }
