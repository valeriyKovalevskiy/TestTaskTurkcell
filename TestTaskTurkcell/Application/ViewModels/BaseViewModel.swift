//
//  BaseViewModel.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import Foundation

internal class BaseViewModel {
    // MARK: - Providers
    let dataProvider = CartDataProvider()
    let imageProvider = ImageProvider()
    
    // MARK: - State
    enum ViewState {
        case loaded
        case loading
        case badConnection
        case badResponse
        case error(Error)
        case unknown
    }
    
    // MARK: - Properties
    var isReachable: Bool {
        switch Reach().connectionStatus() {
        case .offline:
            return false
        case .unknown:
            return false
        default:
            return true
        }
    }
}
