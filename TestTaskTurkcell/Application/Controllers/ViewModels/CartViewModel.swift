//
//  CartViewModel.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import Foundation

protocol CartViewModelDelegate: AnyObject {
    func updateUI(for state: CartViewModel.ViewState)
}

final class CartViewModel {
    weak var delegate: CartViewModelDelegate?

    // MARK: - Properties
    private let dataProvider = CartDataProvider()
    private let imageProvider = ImageProvider()
    
    private var cartResponse: Cart = Cart(products: []) {
        didSet {
            viewState = .loading
            createCartItemsArray(from: cartResponse)
        }
    }

    private(set) var cartItems = [CartItem]() {
        didSet {
            if cartItems.count == cartResponse.products.count {
                viewState = .loaded
            }
        }
    }
    
    // MARK: - View State
    private(set) var viewState: ViewState = .unknown {
        didSet {
            delegate?.updateUI(for: viewState)
        }
    }

    enum ViewState {
        case loaded
        case loading
        case badConnection
        case unknown
    }
    
    private var isReachable: Bool {
        switch Reach().connectionStatus() {
        case .offline:
            viewState = .badConnection
            return false
        case .unknown:
            viewState = .badConnection
            return false
        default:
            return true
        }
    }

    // MARK: - Private
    private func createCartItemsArray(from cart: Cart) {
        cartItems = []
        cart.products.forEach {
            let responseItem = $0
            if isReachable {
                self.imageProvider.loadImage(from: responseItem.imageUrl) { image in
                    let cartItem = CartItem(id: responseItem.id,
                                            name: responseItem.name,
                                            price: responseItem.price,
                                            image: image)
                    self.cartItems.append(cartItem)
                }
            }
        }
    }
    
    
    // MARK: - Open methods
    func downloadCartItems(completion: ((Bool) -> Void)? = nil) {
        viewState = .loading
        
        if isReachable {
            dataProvider.loadCartList { [weak self] result in
                self?.cartResponse = result
                completion?(true)
            }
        }
    }
    
    func downloadDetailedItem(item: String, completion: @escaping (DetailedCartItem) -> Void) {
        if isReachable {
            dataProvider.loadItem(item) { [weak self] detailedItem in
                self?.imageProvider.loadImage(from: detailedItem.imageUrl) { image in
                    let cartItem = DetailedCartItem(id: detailedItem.id,
                                                    name: detailedItem.name,
                                                    price: detailedItem.price,
                                                    image: image,
                                                    description: detailedItem.description)
                    completion(cartItem)
                }
            }
        }
    }
    
}
