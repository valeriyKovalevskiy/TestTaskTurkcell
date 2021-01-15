//
//  ImagesRequests.swift
//  TestTaskTurkcell
//
//  Created by Valeriy Kovalevskiy on 1/15/21.
//

import Foundation
import Alamofire

final class ImageRequests: BaseNetworkService {
    
    @discardableResult
    static func getImage(_ imageURLString: String,
                         successHandler: @escaping NetworkSuccessHandler,
                         errorHandler: @escaping NetworkErrorHandler,
                         progressHandler: @escaping NetworkProgressHandler) -> DataRequest {
        
        BaseNetworkService.downloadImage(from: imageURLString,
                                         successHandler: successHandler,
                                         errorHandler: errorHandler,
                                         progressHandler: progressHandler)
    }
    
}
