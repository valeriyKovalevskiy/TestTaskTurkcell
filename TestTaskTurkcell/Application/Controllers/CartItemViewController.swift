//
//  CartItemViewController.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import UIKit

final class CartItemViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: - Properties
    var viewModel = CartItemViewModel() {
        didSet {
            viewModel.delegate = self
        }
    }
    var item: CartItem = CartItem.emptyCartItem

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextAlignment()
        viewModel.downloadDetailedItem(item: item.id)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        configureTextAlignment()
    }
    
    // MARK: - Private
    private func configureTextAlignment() {
        [nameLabel, priceLabel, descriptionLabel].forEach {
            $0?.textAlignment = UIDevice.current.orientation.isLandscape ? .left : .center
        }
    }
}

extension CartItemViewController: CartItemViewModelDelegate {
    func updateUI(for state: CartItemViewModel.ViewState) {
        DispatchQueue.main.async {
            switch state {
            case .loaded:
                self.title = "loaded"
                let detailedItem = self.viewModel.detailedCartItem
                self.imageView.image = detailedItem.image
                self.nameLabel.text = detailedItem.name
                self.descriptionLabel.text = detailedItem.description
                self.priceLabel.text = "\(String(describing: detailedItem.price)) $"
                
            case .badConnection:
                self.title = "bad connection"

            case .loading:
                self.title = "loading"
                self.imageView.image = self.item.image
                self.nameLabel.text = self.item.name
                self.descriptionLabel.text = "Description was missed"
                self.priceLabel.text = "\(String(describing: self.item.price)) $"
                
            case .badResponse:
                self.title = "bad response"
                self.imageView.image = self.item.image
                self.nameLabel.text = self.item.name
                self.descriptionLabel.text = "Description was missed"
                self.priceLabel.text = "\(String(describing: self.item.price)) $"

            case .error(let error):
                self.title = error.localizedDescription
                
            default:
                self.title = "unknown state"
            }
        }
    }
        
}
