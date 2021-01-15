//
//  RootViewController.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import UIKit

final class SplashViewController: UIViewController {
    @IBOutlet private weak var loadingActivityIndicator: UIActivityIndicatorView!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        createNetworkingRequests()
        setInitialController()
    }
    
    deinit {
        print("splash was deinit")
    }

    // MARK: - Private Methods
    private func createNetworkingRequests() {
        loadingActivityIndicator.startAnimating()
        


    }

    private func setInitialController() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            AppDelegate.shared.rootViewController.showFeedViewController()
            self.loadingActivityIndicator.stopAnimating()
        }
    }
}
