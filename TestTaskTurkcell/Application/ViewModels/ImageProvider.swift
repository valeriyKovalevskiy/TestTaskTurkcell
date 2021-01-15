//
//  ImageProvider.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import UIKit

class ImageProvider {

    
    func loadImage(from imageUrl: String, completion: @escaping (UIImage) -> Void) {
        
        ServerCommunication.getImage(from: imageUrl, completion: { [weak self] (response, error) in
            guard let strongSelf = self else { return }
            
            if let response = response, let image = response["image"] as? UIImage {
                completion(image)
            } else if let error = error {
                print(error)
            }
        }, progressHandler: { (progress) in
            //ignore
        })
    }
}

