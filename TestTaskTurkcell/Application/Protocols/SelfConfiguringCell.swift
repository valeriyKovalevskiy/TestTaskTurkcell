//
//  SelfConfiguringCell.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
}

extension SelfConfiguringCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
