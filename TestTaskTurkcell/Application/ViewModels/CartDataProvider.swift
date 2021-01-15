//
//  CartDataProvider.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import Foundation

class CartDataProvider {

    // MARK: - Open methods
//    func load<T: Codable>(completion: @escaping ([T]) -> Void) {
//        ServerCommunication.getCartList { [weak self] (response, error) in
//            guard let error = error else {
//                    ParsingManager.shared.parse(from: response, completion: completion)
//                return
//            }
//
//            print(error.localizedDescription)
//        }
//    }
    
    func load(completion: @escaping (Cart) -> Void) {
        ServerCommunication.getCartList { (response, error) in
            if let response = response {
                if let data = try? JSONSerialization.data(withJSONObject: response, options: []) {
                    let decoder = JSONDecoder()
                    if let decoded = try? decoder.decode(Cart.self, from: data) {
                        print(decoded)
                        completion(decoded)
                    }

                }

            }
        }
    }
    
    
}


