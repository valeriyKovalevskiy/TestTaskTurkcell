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
    
    private var itemResponse: DetailedCartItemResponse? {
        didSet {
            createItem(from: itemResponse)
        }
    }

    private(set) var detailedCartItem: DetailedCartItem? {
        didSet {
            viewState = .loaded
        }
    }

    private func createItem(from detailedItemResponse: DetailedCartItemResponse?) {
        guard let response = detailedItemResponse else { return }
        guard isReachable else { return viewState = .badConnection }
        
        self.imageProvider.loadImage(from: response.imageUrl) { [weak self] image in
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
        dataProvider.loadItem(item) { [weak self] detailedItem in
            self?.itemResponse = detailedItem
        }
    }
}
