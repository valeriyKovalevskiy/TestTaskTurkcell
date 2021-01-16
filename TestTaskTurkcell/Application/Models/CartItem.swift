//
//  CartItem.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import UIKit
import Foundation

//swiftlint:disable image_name_initialization
struct CartItem: Equatable {
    let id: String
    let name: String
    let price: Int
    let image: UIImage
}

struct DetailedCartItem: Equatable {
    var id: String?
    var name: String?
    var price: Int?
    var image: UIImage?
    var description: String?
}
