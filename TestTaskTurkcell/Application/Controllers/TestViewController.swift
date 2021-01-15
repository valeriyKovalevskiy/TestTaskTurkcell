//
//  TestViewController.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction private func buttonTapped(_ sender: Any) {
        AppDelegate.shared.rootViewController.showFeedViewController()
    }
    
}
