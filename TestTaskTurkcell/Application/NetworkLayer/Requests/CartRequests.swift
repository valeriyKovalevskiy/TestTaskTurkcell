//
//  CartRequests.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import Foundation

final class CartRequests: BaseNetworkService {
    
    static func getCartList(successHandler: @escaping NetworkSuccessHandler,
                            errorHandler: @escaping NetworkErrorHandler) {
        
        CartRequests.sendRequest(.get,
                                 request: Requests.getCartList.path,
                                 successHandler: successHandler,
                                 errorHandler: errorHandler)
    }
    
    static func getCartItemDetails(for id: String,
                                   successHandler: @escaping NetworkSuccessHandler,
                                   errorHandler: @escaping NetworkErrorHandler) {
        
        CartRequests.sendRequest(.get,
                                 request: Requests.getItemDetails(id: id).path,
                                 successHandler: successHandler,
                                 errorHandler: errorHandler)
    }
}
