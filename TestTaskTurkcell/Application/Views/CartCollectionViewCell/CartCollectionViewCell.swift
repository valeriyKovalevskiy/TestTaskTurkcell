//
//  CartCollectionViewCell.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import UIKit

final class CartCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {
    // MARK: - Outlets
    @IBOutlet private weak var labelsStackView: UIStackView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var desctiptionLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!

    // MARK: - Open
    func update(name: String,
                price: String,
                image: UIImage) {
        desctiptionLabel.text = name
        priceLabel.text = price
        imageView.image = image
    }
}
