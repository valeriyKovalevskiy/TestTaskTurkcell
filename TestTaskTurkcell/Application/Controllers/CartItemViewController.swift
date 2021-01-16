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
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    var image: UIImage?
    var nameText: String?
    var descriptionText: String?
    var priceText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
        nameLabel.text = nameText
        descriptionLabel.text = descriptionText
        priceLabel.text = priceText
    }
}
