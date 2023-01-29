//
//  Array+Extension.swift
//  QCM
//
//  Created by Sofien Benharchache on 29/01/2023.
//

import Foundation

extension Array where Element : Sort {
    // Sort current array by order.
    mutating func sort() {
        self = self.sorted { $0.order < $1.order }
    }
}
