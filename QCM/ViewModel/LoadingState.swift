//
//  LoadingState.swift
//  QCM
//
//  Created by Sofien Benharchache on 29/01/2023.
//

import Foundation

enum LoadingState {
    case idle
    case loading
    case success
    case error (Error)
}

extension LoadingState: Equatable {
    static func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.success, .success): return true
        case (let .error(error_lhs), let .error(error_rhs)):
            return error_lhs.localizedDescription == error_rhs.localizedDescription
        default: return false
        }
    }
}
