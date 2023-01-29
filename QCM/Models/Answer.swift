//
//  Answer.swift
//  QCM
//
//  Created by Sofien Benharchache on 28/01/2023.
//

import Foundation

struct Answer {
    let id: UInt!
    let choices: [Choice]
}

extension Answer: Decodable { }
