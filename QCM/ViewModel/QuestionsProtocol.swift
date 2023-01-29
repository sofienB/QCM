//
//  QuestionsProtocol.swift
//  QCM
//
//  Created by Sofien Benharchache on 29/01/2023.
//

import Foundation

protocol QuestionsProtocol : AnyObject {
    func didUpdate(state: LoadingState)
}
