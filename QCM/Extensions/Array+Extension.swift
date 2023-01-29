//
//  Array+Extension.swift
//  QCM
//
//  Created by Sofien Benharchache on 29/01/2023.
//

import Foundation

// MARK: - Sort Array.
extension Array where Element : Sort {
    // Sort current array by order.
    mutating func sort() {
        self = self.sorted { $0.order < $1.order }
    }
}

// MARK: - Convert Array as Json data.
extension Array where Element == Answer {
    func toJson() -> Data? {
        let json: Data?
        do {
            json = try JSONEncoder().encode(self)
            return json
        } catch {
            print(error)
        }
        return nil
    }
}
