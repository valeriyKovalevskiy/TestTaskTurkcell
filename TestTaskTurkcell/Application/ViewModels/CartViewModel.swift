//
//  CartViewModel.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import Foundation
import UIKit

protocol CartViewModelDelegate: AnyObject {
    func updateUI(for state: CartViewModel.ViewState)
}

final class CartViewModel: BaseViewModel {
    weak var delegate: CartViewModelDelegate?
    
    // MARK: - View State
    private(set) var viewState: ViewState = .unknown {
        didSet {
            delegate?.updateUI(for: viewState)
        }
    }
    
    private var cartResponse = Cart(products: []) {
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

    // MARK: - Private
    private func createCartItemsArray(from cart: Cart) {
        cartItems = []
        cart.products.forEach {
            let responseItem = $0
            guard isReachable else { return viewState = .badConnection }
            
            self.imageProvider.loadImage(from: responseItem.imageUrl) { [weak self] image, error in
                guard let image = image else {
                    self?.viewState = .badResponse
                    return
                }
                
                if let error = error {
                    self?.viewState = .error(error)
                }
                
                self?.cartItems.append(CartItem(id: responseItem.id,
                                               name: responseItem.name,
                                               price: responseItem.price,
                                               image: image))
            }
        }
    }
    
    // MARK: - Open methods
    func downloadCartItems() {
        guard isReachable else { return viewState = .badConnection }
        
        viewState = .loading
        dataProvider.loadCartList { [weak self] response, error in
            guard let itemResponse = response else {
                self?.viewState = .badResponse
                return
            }
            
            if let error = error {
                self?.viewState = .error(error)
            }
            
            self?.cartResponse = itemResponse
        }
    }
    
    func navigateToCartItemViewController(for indexPath: IndexPath, from viewController: UIViewController, completion: (() -> Void)? = nil) {
        let storyboard = UIStoryboard(name: Constants.Controllers.CartItemViewController, bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: Constants.Controllers.CartItemViewController) as? CartItemViewController {
            controller.item = cartItems[indexPath.item]
            controller.viewModel = CartItemViewModel()
            viewController.navigationController?.pushViewController(controller, animated: true)
            completion?()
        }
    }
}
