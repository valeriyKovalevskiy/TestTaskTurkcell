import Foundation

typealias CompletionBlock = (_ response: [String: Any]?, _ error: Error?) -> Void

final class ServerCommunication {
    // MARK: - Cart Requests
    static func getCartList(completion: @escaping CompletionBlock) {
        
        CartRequests.getCartList(successHandler: ServerCommunication.successHandler(completion),
                                 errorHandler: ServerCommunication.errorHandler(completion))
    }
    
    static func getCartItemDetails(item: String,
                                   completion: @escaping CompletionBlock) {
        
        CartRequests.getCartItemDetails(for: item,
                                        successHandler: ServerCommunication.successHandler(completion),
                                        errorHandler: ServerCommunication.errorHandler(completion))
    }

    // MARK: - Images resuests
    static func getImage(from imageURLString: String,
                         completion: @escaping CompletionBlock,
                         progressHandler: @escaping NetworkProgressHandler) {
        
        ImageRequests.getImage(imageURLString,
                               successHandler: ServerCommunication.successHandler(completion),
                               errorHandler: ServerCommunication.errorHandler(completion),
                               progressHandler: progressHandler)
    }

}

private extension ServerCommunication {
    static func successHandler(_ completion: @escaping CompletionBlock) -> NetworkSuccessHandler {
        
        let successHandler: NetworkSuccessHandler = { response in
            guard let error = response?["error"] else { return completion(response, nil) }
            
            completion(nil, error as? Error)
        }
        return successHandler
    }
    
    static func errorHandler(_ completion: @escaping CompletionBlock) -> NetworkErrorHandler {
        
        let errorHandler: NetworkErrorHandler = { error in
            completion(nil, error)
        }
        return errorHandler
    }
    
}
