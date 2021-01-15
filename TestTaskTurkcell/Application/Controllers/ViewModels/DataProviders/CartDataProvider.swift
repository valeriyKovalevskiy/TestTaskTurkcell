//
//  CartDataProvider.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import Foundation

final class CartDataProvider {
    func load(completion: @escaping (Cart) -> Void) {
        ServerCommunication.getCartList { (response, error) in
            if let error = error {
                // TODO: - Handle
            }
            if let response = response {
                if let data = try? JSONSerialization.data(withJSONObject: response, options: []) {
                    let decoder = JSONDecoder()
                    if let decoded = try? decoder.decode(Cart.self, from: data) {
                        completion(decoded)
                    }
                }
            }
        }
    }
}
