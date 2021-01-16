//
//  CartDataProvider.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import Foundation

final class CartDataProvider {
    func loadCartList(completion: @escaping (Cart) -> Void) {
        ServerCommunication.getCartList { (response, error) in
            if let error = error {
                // TODO: - Handle
            }
            if let response = ParsingService<Cart>().parseObject(response) {
                completion(response)
            } else {
                print("bad response \(response)")
            }
        }
    }
    
    func loadItem(_ item: String, completion: @escaping (DetailedCartItemResponse) -> Void) {
        ServerCommunication.getCartItemDetails(item: item) { (response, error) in
            if let error = error {
                // TODO: - Handle
            }
            
            if let response = ParsingService<DetailedCartItemResponse>().parseObject(response) {
                completion(response)
            } else {
                print("bad response \(response)")
            }
        }
    }
}
