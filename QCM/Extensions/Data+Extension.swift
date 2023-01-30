//
//  Data+Extension.swift
//  QCM
//
//  Created by Sofien Benharchache on 29/01/2023.
//

import Foundation

extension Data {
    func toString() -> String? {
        if let string = String(data: self, encoding: .utf8) {
           return string
        } else {
            print("Error : data cann't be converted")
        }
        return nil
    }
}
