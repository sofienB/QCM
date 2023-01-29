//
//  Sort.swift
//  QCM
//
//  Created by Sofien Benharchache on 29/01/2023.
//

import Foundation

protocol Sort {
    var order: UInt8! { get }
}

extension Sort {
    static func < (lhs: Sort, rhs: Sort) -> Bool {
        let lorder = lhs
        let rorder = rhs
        guard let lorder = lorder.order,
              let rorder = rorder.order
        else { return false }
        return lorder < rorder
    }
}
