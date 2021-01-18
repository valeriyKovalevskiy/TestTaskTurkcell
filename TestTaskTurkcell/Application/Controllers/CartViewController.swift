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
    private var additionalPadding: CGFloat = 0
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
        
        configureAdditionalPadding()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Private
    private func setupCollectionView() {
        configureAdditionalPadding()
        
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
    
    @objc private func refreshView(sender: UIRefreshControl) {
        viewModel.downloadCartItems()
    }
    
    private func configureAdditionalPadding() {
        if UIDevice.iPhoneXRorMore {
            UIDevice.current.orientation.isLandscape ?
                (additionalPadding = 100) :
                (additionalPadding = 0)
            
        }
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
                
            case .badResponse:
                self.title = "bad response"
            
            case .error(let error):
                self.title = error.localizedDescription
                
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
        
        viewModel.navigateToCartItemViewController(for: indexPath, from: self)
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
        let availableWidth = view.frame.width - paddingSpace - additionalPadding
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
