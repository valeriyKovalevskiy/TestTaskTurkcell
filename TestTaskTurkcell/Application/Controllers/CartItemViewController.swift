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
    var viewModel = CartItemViewModel()
    
    var id: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.downloadDetailedItem(item: id)
    }
}

extension CartItemViewController: CartItemViewModelDelegate {
    func updateUI(for state: CartItemViewModel.ViewState) {
        DispatchQueue.main.async {
            switch state {
            case .loaded:
                self.title = "loaded"
                
                let detailedItem = self.viewModel.detailedCartItem
                self.imageView.image = detailedItem?.image
                self.nameLabel.text = detailedItem?.name
                self.descriptionLabel.text = detailedItem?.description
                self.priceLabel.text = "\(String(describing: detailedItem?.price))"
                
            case .badConnection:
                self.title = "bad connection"

            case .loading:
                self.title = "loading"
                
            default:
                self.title = "feed"
            }
        }
    }
        
}
