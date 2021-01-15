//
//  CartViewModel.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import Foundation

protocol CartViewModelDelegate: AnyObject {
    func updateCollectionView()
}

final class CartViewModel {
    // MARK: - Properties
    fileprivate let dataProvider = CartDataProvider()
    fileprivate let imageProvider = ImageProvider()
    
    weak var delegate: CartViewModelDelegate?
    
    var cartItemsArray = [CartItem]() {
        didSet {
            if cartItemsArray.count == cartResponse.products.count {
                delegate?.updateCollectionView()
            }
        }
    }
    
    var cartResponse: Cart = Cart(products: []) {
        didSet {
            createCartItemsArray(from: cartResponse)
        }
    }
    
    // MARK: - Open methods
    func downloadCartItems(completion: ((Bool) -> Void)? = nil) {
        dataProvider.load { [weak self] result in
            self?.cartResponse = result
            completion?(true)
        }
    }
    
    // MARK: - Private
    private func createCartItemsArray(from cart: Cart) {
        cart.products.forEach {
            
            let responseItem = $0
            self.imageProvider.loadImage(from: responseItem.imageUrl) { image in
                let cartItem = CartItem(id: responseItem.id,
                                        name: responseItem.name,
                                        price: responseItem.price,
                                        image: image)
                self.cartItemsArray.append(cartItem)
            }
        }
    }
}
