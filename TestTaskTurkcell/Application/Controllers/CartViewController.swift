//
//  CartViewController.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import UIKit
import Foundation

final class CartViewController: UIViewController {
    // MARK: - Outlets
    private var refreshControl: UIRefreshControl!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var loadingView: LoadingView!
    @IBOutlet private weak var badConnectionView: BadConnectionView! {
        didSet {
            badConnectionView.delegate = self
        }
    }
    
    // MARK: - Properties
    var viewModel = CartViewModel() {
        didSet {
            viewModel.delegate = self
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupRefreshControl()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Private
    private func setupCollectionView() {
        let nib = UINib(nibName: CartCollectionViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: CartCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    // MARK: - Actions
    @objc private func refreshView(sender: UIRefreshControl) {
        viewModel.downloadCartItems()
    }
}

// MARK: - ViewModel delegate
extension CartViewController: CartViewModelDelegate {
    func updateUI(for state: CartViewModel.ViewState) {
        DispatchQueue.main.async {
            switch state {
            case .loaded:
                self.title = "loaded"
                self.loadingView.hide()
                self.badConnectionView.hide()
                self.refreshControl.endRefreshing()
                self.collectionView.reloadData()
                
            case .badConnection:
                self.title = "bad connection"
                self.loadingView.hide()
                self.refreshControl.endRefreshing()
                self.badConnectionView.show()
                
            case .loading:
                self.title = "loading"
                self.loadingView.show()
                self.collectionView.reloadData()
                
            default:
                self.title = "feed"
                self.collectionView.reloadData()
            }
        }
    }
}

extension CartViewController: BadConnectionViewDelegate {
    func updateView() {
        viewModel.downloadCartItems()
    }
}
// MARK: - Collection View Delegate
extension CartViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        //        let selectedCell = collectionView.cellForItem(at: indexPath)
        //        selectedCell?.isUserInteractionEnabled = false
        let item = viewModel.cartItems[indexPath.item]
        
        viewModel.downloadDetailedItem(item: item.id) { [weak self] item in
            let storyboard = UIStoryboard(name: Constants.Controllers.CartItemViewController, bundle: nil)
            if let controller = storyboard.instantiateViewController(withIdentifier: Constants.Controllers.CartItemViewController) as? CartItemViewController {
                controller.image = item.image
                controller.nameText = item.name
                controller.descriptionText = item.description
                controller.priceText = "\(item.price)"
                //                selectedCell?.isUserInteractionEnabled = true
                self?.navigationController?.pushViewController(controller, animated: true)
            }
            
        }
    }
    
}

// MARK: - Collection View Data Source
extension CartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        viewModel.cartItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? CartCollectionViewCell else { return UICollectionViewCell() }
        
        let item = viewModel.cartItems[indexPath.item]
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
