//
//  CartItemViewModel.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import Foundation

protocol CartItemViewModelDelegate: AnyObject {
    func updateUI(for state: CartViewModel.ViewState)
}

final class CartItemViewModel: BaseViewModel {
    weak var delegate: CartItemViewModelDelegate?
    
    // MARK: - View State
    private(set) var viewState: ViewState = .unknown {
        didSet {
            delegate?.updateUI(for: viewState)
        }
    }
    
    // MARK: - Properties
    private var itemResponse: DetailedCartItemResponse? {
        didSet {
            createItem(from: itemResponse)
        }
    }

    private(set) var detailedCartItem: DetailedCartItem = DetailedCartItem.emptyDetailedItem {
        didSet {
            viewState = .loaded
        }
    }

    // MARK: - Private
    private func createItem(from detailedItemResponse: DetailedCartItemResponse?) {
        guard let response = detailedItemResponse else { return }
        guard isReachable else { return viewState = .badConnection }
        
        self.imageProvider.loadImage(from: response.imageUrl) { [weak self] image, error in
            guard let image = image else {
                self?.viewState = .badResponse
                return
            }
            
            if let error = error {
                self?.viewState = .error(error)
            }
            
            self?.detailedCartItem = DetailedCartItem(id: response.id,
                                                      name: response.name,
                                                      price: response.price,
                                                      image: image,
                                                      description: response.description)
        }
    }
    
    // MARK: - Open
    func downloadDetailedItem(item: String) {
        guard isReachable else { return viewState = .badConnection }
        
        viewState = .loading
        dataProvider.loadItem(item) { [weak self] response, error  in
            guard let itemResponse = response else {
                self?.viewState = .badResponse
                return
            }
            
            if let error = error {
                self?.viewState = .error(error)
            }
            
            self?.itemResponse = itemResponse
        }
    }
}
