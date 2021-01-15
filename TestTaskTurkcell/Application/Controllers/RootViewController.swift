//
//  RootViewController.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import UIKit

final class RootViewController: UIViewController {
    // MARK: - Properties
    private var currentViewController: UIViewController!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSplashScreen()
    }

    // MARK: - Internal Methods
    func showFeedViewController() {
        let storyboard = UIStoryboard(name: Constants.Controllers.FeedViewController, bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: Constants.Controllers.FeedViewController) as? FeedViewController {
            let feedViewController = UINavigationController(rootViewController: controller)
            animateFadeTransition(to: feedViewController)
        }
    }
    
    func showTestViewController() {
        let storyboard = UIStoryboard(name: "TestViewController", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "TestViewController") as? TestViewController {
            let feedViewController = UINavigationController(rootViewController: controller)
            animateFadeTransition(to: feedViewController)
        }
    }

    // MARK: - Private Methods
    private func setupSplashScreen() {
        let storyboard = UIStoryboard(name: Constants.Controllers.SplashViewController, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: Constants.Controllers.SplashViewController) as? SplashViewController
        currentViewController = controller

        addChild(currentViewController)
        currentViewController.view.frame = view.bounds
        view.addSubview(currentViewController.view)
        currentViewController.didMove(toParent: self)
    }

    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        currentViewController.willMove(toParent: nil)
        addChild(new)
        transition(from: currentViewController,
                   to: new,
                   duration: 0.3,
                   options: [.transitionCrossDissolve, .curveEaseOut],
                   animations: {},
                   completion: { _ in
                    self.currentViewController.removeFromParent()
                    new.didMove(toParent: self)
                    self.currentViewController = new
                    completion?()
                   })
    }
}

// MARK: - Navigation extension
extension AppDelegate {
    static var shared: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }

    var rootViewController: RootViewController {
        window!.rootViewController as! RootViewController
    }
}
