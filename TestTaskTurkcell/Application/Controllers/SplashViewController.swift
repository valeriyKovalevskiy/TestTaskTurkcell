//
//  RootViewController.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import UIKit

final class SplashViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        createNetworkingRequests()
    }
    
    deinit {
        print("splash was deinit")
    }

    // MARK: - Private Methods
    private func createNetworkingRequests() {
        loadingActivityIndicator.startAnimating()
        
        let cartViewModel = CartViewModel()
        cartViewModel.downloadCartItems()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadingActivityIndicator.stopAnimating()
            AppDelegate.shared.rootViewController.showCartViewController(with: cartViewModel)
        }
    }
}
