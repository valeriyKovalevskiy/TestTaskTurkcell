//
//  CartViewModel.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import Foundation

class CartViewModel {

    
    fileprivate let provider = CartDataProvider()
    var dataSource = Cart(products: [])
    // MARK: - Open methods
    func getCartItems(completion: @escaping () -> Void) {
        
        provider.load { result in
            
            
            self.dataSource = result
            
            
            result.products.forEach {
                
            }
            completion()
        }
    }

}
