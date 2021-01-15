//
//  PropertyRequests.swift
//  IMMOMIG
//
//  Created by Maksym Lazebnyi on 1/15/21.
//  Copyright © 2016 Maksym Lazebnyi. All rights reserved.
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
