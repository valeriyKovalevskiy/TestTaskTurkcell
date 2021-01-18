//
//  ImageProvider.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import UIKit

typealias ImageCompletionBlock = (_ response: UIImage?, _ error: Error?) -> Void

final class ImageProvider {
    func loadImage(from imageUrl: String, completion: @escaping ImageCompletionBlock) {
        ServerCommunication.getImage(from: imageUrl, completion: {(response, error) in
            if let error = error {
                completion(nil, error)
            }

            guard let response = response, let image = response["image"] as? UIImage else {
                completion(nil, nil)
                return
            }
            
            completion(image, nil)

        }, progressHandler: { _ in })
    }
}

