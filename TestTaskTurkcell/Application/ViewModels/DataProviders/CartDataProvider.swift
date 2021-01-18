//
//  CartDataProvider.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import Foundation

typealias CartCompletionBlock = (_ response: Cart?, _ error: Error?) -> Void
typealias ItemCompletionBlock = (_ response: DetailedCartItemResponse?, _ error: Error?) -> Void

final class CartDataProvider {
    func loadCartList(completion: @escaping CartCompletionBlock) {
        ServerCommunication.getCartList { (response, error) in
            if let error = error {
                completion(nil, error)
            }
            
            guard let response = ParsingService<Cart>().parseObject(response) else {
                completion(nil, nil)
                return
            }
            
            completion(response, nil)
        }
    }

    func loadItem(_ item: String, completion: @escaping ItemCompletionBlock) {
        ServerCommunication.getCartItemDetails(item: item) { (response, error) in
            if let error = error {
                completion(nil, error)
            }
            
            guard let response = ParsingService<DetailedCartItemResponse>().parseObject(response) else {
                completion(nil, nil)
                return
            }
            
            completion(response, nil)
        }
    }
}
