//
//  DetailedCartItem.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import Foundation
import UIKit

//swiftlint:disable image_name_initialization
struct DetailedCartItem: Equatable {
    var id: String
    var name: String
    var price: Int
    var image: UIImage
    var description: String
    
    static let emptyDetailedItem = DetailedCartItem(id: "",
                                                    name: "",
                                                    price: -1,
                                                    image: UIImage(named: "placeholder")!,
                                                    description: "")
}
