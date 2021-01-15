//
//  CartViewController.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import UIKit
import Foundation

//swiftlint:disable image_name_initialization
final class CartViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    var viewModel = CartViewModel() {
        didSet {
            viewModel.delegate = self
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    deinit {
        print("cart view deinit")
    }
    
    // MARK: - Private
    private func setupView() {
        title = "Feed"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: CartCollectionViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: CartCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
}

// MARK:
extension CartViewController: CartViewModelDelegate {
    func updateCollectionView() {
        self.collectionView.reloadData()
    }
}

// MARK: - Collection View Delegate
extension CartViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        let item = viewModel.cartItemsArray[indexPath.item]
        let storyboard = UIStoryboard(name: Constants.Controllers.CartItemViewController, bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: Constants.Controllers.CartItemViewController) as? CartItemViewController {
            controller.image = UIImage(named: "1")!
            controller.descriptionText = item.name
            controller.priceText = "\(item.price)"
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

// MARK: - Collection View Data Source
extension CartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        viewModel.cartItemsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? CartCollectionViewCell else {
            fatalError("Wrong cell")
        }
        
        let item = viewModel.cartItemsArray[indexPath.item]
        cell.update(name: item.name,
                    price: "\(item.price)",
                    image: item.image)
        return cell
    }
}

// MARK: - Collection View Flow Layout Delegate
extension CartViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let horizontalItemsPerRow: CGFloat = 2
        let verticalItemsPerRow: CGFloat = 2
        let itemsPerRow = UIDevice.current.orientation.isPortrait ? verticalItemsPerRow : horizontalItemsPerRow
        let sectionInsets = Constants.Layout.CollectionViewEdgeInsets
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let itemWidth = availableWidth / itemsPerRow
        let itemHeight = UIDevice.current.orientation.isPortrait ? view.frame.height / 3 : view.frame.height / 2
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        Constants.Layout.CollectionViewEdgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        Constants.Layout.CollectionViewEdgeInsets.left
    }
}
