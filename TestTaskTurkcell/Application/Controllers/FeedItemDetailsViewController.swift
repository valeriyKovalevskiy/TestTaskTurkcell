//
//  FeedItemDetailsViewController.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import UIKit

final class FeedItemDetailsViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    var image: UIImage?
    var descriptionText: String?
    var priceText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
        descriptionLabel.text = descriptionText
        priceLabel.text = priceText
    }
    
    @IBAction private func testButton(_ sender: UIButton) {
        AppDelegate.shared.rootViewController.showTestViewController()
    }
}
