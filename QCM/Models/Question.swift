//
//  Question.swift
//  QCM
//
//  Created by Sofien Benharchache on 27/01/2023.
//

import Foundation

struct Question : Sort {
    
    let id: UInt!
    let name: String!
    var order: UInt8!
    let choices: [Choice]!
    let question: String!
    let multiple: Bool!
}

extension Question: Decodable { }
