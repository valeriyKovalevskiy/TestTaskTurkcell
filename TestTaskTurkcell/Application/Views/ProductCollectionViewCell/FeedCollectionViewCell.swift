//
//  FeedCollectionViewCell.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import UIKit

final class FeedCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {
    // MARK: - Outlets
    @IBOutlet private weak var labelsStackView: UIStackView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var desctiptionLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!

    func update(desctiption: String,
                price: String,
                imageUrl: String) {
        desctiptionLabel.text = desctiption
        priceLabel.text = price
        
        ServerCommunication.getImage(from: imageUrl, completion: { [weak self] (response, error) in
            guard let strongSelf = self else { return }
            
            if let response = response, let image = response["image"] as? UIImage {
                strongSelf.imageView.image = image
            } else if let error = error {
                // TODO: - Handle
                print(error)
            }
        }, progressHandler: { (progress) in
            //ignore
        })
    }

}


