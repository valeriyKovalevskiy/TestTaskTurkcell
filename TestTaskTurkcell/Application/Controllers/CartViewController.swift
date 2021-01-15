//
//  FeedViewController.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import UIKit
import Foundation

//swiftlint:disable image_name_initialization
final class FeedViewController: UIViewController {
    // MARK: - Properties
    let viewModel = CartViewModel()
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupCollectionView()
        setupDataSource()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    deinit {
        print("collection view deinit")
    }
    
    // MARK: - Private
    private func setupView() {
        title = "Feed"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: FeedCollectionViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: FeedCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    private func setupDataSource() {

        viewModel.getCartItems { [weak self] in
            self?.collectionView.reloadData()
        }
//        datasource.append(CartItem(price: "124", description: "fsggfd", image: UIImage(named: "1")! ))
//        datasource.append(CartItem(price: "124", description: "fsggfdfsggfdfsggfdfsggfd", image: UIImage(named: "2")! ))
//        datasource.append(CartItem(price: "124", description: "fsggfd", image: UIImage(named: "3")! ))
//        datasource.append(CartItem(price: "124", description: "fsggfdfsggfdfsggfdfsggfdfsggfdfsggfdfsggfdfsggfdfsggfd", image: UIImage(named: "4")! ))
//        datasource.append(CartItem(price: "124", description: "fsggfdfsggfdfsggfdfsggfdfsggfdfsggfdfsggfdfsggfdfsggfd", image: UIImage(named: "5")! ))
//        datasource.append(CartItem(price: "124", description: "fsggfd", image: UIImage(named: "6")! ))
//        datasource.append(CartItem(price: "124", description: "fsggfd", image: UIImage(named: "7")! ))
//        datasource.append(CartItem(price: "124", description: "fsggfdfsggfdfsggfdfsggfd", image: UIImage(named: "8")! ))
//        datasource.append(CartItem(price: "124", description: "fsggfdfsggfdfsggfdfsggfdfsggfdfsggfd", image: UIImage(named: "9")! ))
//        datasource.append(CartItem(price: "124", description: "fsggfd", image: UIImage(named: "20")! ))
//        datasource.append(CartItem(price: "124", description: "fsggfdfsggfdfsggfdfsggfdfsggfdfsggfdfsggfd", image: UIImage(named: "11")! ))
//        datasource.append(CartItem(price: "124", description: "fsggfdfsggfdfsggfd", image: UIImage(named: "12")! ))
//        datasource.append(CartItem(price: "124", description: "fsggfd", image: UIImage(named: "13")! ))
//        datasource.append(CartItem(price: "124", description: "fsggfd", image: UIImage(named: "14")! ))
//        datasource.append(CartItem(price: "124", description: "fsggfd", image: UIImage(named: "15")! ))
//        datasource.append(CartItem(price: "124", description: "fsggfd", image: UIImage(named: "10")! ))
//        datasource.append(CartItem(price: "124", description: "fsggfd", image: UIImage(named: "16")! ))
//        datasource.append(CartItem(price: "124", description: "fsggfd", image: UIImage(named: "17")! ))
//        datasource.append(CartItem(price: "124", description: "fsggfd", image: UIImage(named: "20")! ))
//        datasource.append(CartItem(price: "124", description: "fsggfd", image: UIImage(named: "18")! ))
//        datasource.append(CartItem(price: "124", description: "fsggfd", image: UIImage(named: "19")! ))

    }
}

// MARK: - Collection View Delegate
extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        let item = viewModel.dataSource.products[indexPath.item]
//        collectionView.cellForItem(at: indexPath)?.shake()
        
        let storyboard = UIStoryboard(name: Constants.Controllers.FeedItemDetailsViewController, bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: Constants.Controllers.FeedItemDetailsViewController) as? FeedItemDetailsViewController {
            controller.image = UIImage(named: "1")!
            controller.descriptionText = item.name
            controller.priceText = "\(item.price)"
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

// MARK: - Collection View Data Source
extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        viewModel.dataSource.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? FeedCollectionViewCell else {
            fatalError("Wrong cell")
        }
        
        let item = viewModel.dataSource.products[indexPath.item]
        cell.update(desctiption: item.name,
                    price: "\(item.price)",
                    imageUrl: item.imageUrl)
        return cell
    }
}

// MARK: - Collection View Flow Layout Delegate
extension FeedViewController: UICollectionViewDelegateFlowLayout {
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
