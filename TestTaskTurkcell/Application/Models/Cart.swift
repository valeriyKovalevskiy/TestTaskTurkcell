//
//  Cart.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import Foundation

struct Cart: Codable {
    let products: [CartItemResponse]
}

struct CartItemResponse: Codable {
    let id: String
    let name: String
    let price: Int
    let imageUrl: String
    
    
    fileprivate enum CodingKeys: String, CodingKey {
        case id = "product_id"
        case name = "name"
        case price = "price"
        case imageUrl = "image"
    }
    
    init(from decoder: Decoder) throws {
        let cartItemResponseContainer = try decoder.container(keyedBy: CodingKeys.self)
        id = try cartItemResponseContainer.decode(String.self, forKey: .id)
        name = try cartItemResponseContainer.decode(String.self, forKey: .name)
        price = try cartItemResponseContainer.decode(Int.self, forKey: .price)
        imageUrl = try cartItemResponseContainer.decode(String.self, forKey: .imageUrl)
    }
}
