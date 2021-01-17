//
//  ImageProvider.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import UIKit

final class ImageProvider {

    func loadImage(from imageUrl: String, completion: @escaping (UIImage) -> Void) {
        
        ServerCommunication.getImage(from: imageUrl, completion: { [weak self] (response, error) in
            if let error = error {
                // TODO: - handle errors
            }
            
            if let response = response, let image = response["image"] as? UIImage {
                completion(image)
            } else {
                print("bad response \(response)")
            }
        }, progressHandler: { _ in })
    }
}

