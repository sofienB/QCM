//
//  Choice.swift
//  QCM
//
//  Created by Sofien Benharchache on 28/01/2023.
//

import Foundation

struct Choice {
    let id: UInt!
    let name: String!
    let order: UInt8!
    let description: String?
}

extension Choice: Decodable { }
