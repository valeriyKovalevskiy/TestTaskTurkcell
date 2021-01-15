//
//  CartItem.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import UIKit
import Foundation

struct CartItem: Codable {
    let id: String
    let name: String
    let price: Int
    let imageUrl: UIImage
}
