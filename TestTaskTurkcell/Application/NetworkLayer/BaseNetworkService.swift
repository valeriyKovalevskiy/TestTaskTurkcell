import Foundation
import Alamofire
import AlamofireImage

typealias NetworkCompletionHandler = (_ respose: AnyObject?, _ error: NSError?) -> Void
typealias NetworkProgressHandler = (_ progress: Double) -> Void

typealias NetworkSuccessHandler = ([String: Any]?) -> Void
typealias NetworkErrorHandler = (Error) -> Void

enum Requests {
    case getCartList
    case getItemDetails(id: String)
    
    var path: String {
        switch self {
        case .getCartList:
            return "cart/list"
        case .getItemDetails(let id):
            return "cart/\(id)/detail"
        }
    }
}

 class BaseNetworkService {
    // MARK: - Properties
    static let alamofireManager = AlamofireManager(configuration: BaseNetworkService.configuration)
    static let baseUrl = "https://s3-eu-west-1.amazonaws.com/developer-application-test"
    static let configuration: URLSessionConfiguration = {
        let conf = URLSessionConfiguration.default
        conf.timeoutIntervalForRequest = 3000
        conf.timeoutIntervalForResource = 3000
        
        return conf
    }()

    static func handleResponseData(_ response: [String: Any]?,
                                   errorHandler: NetworkErrorHandler,
                                   successHandler: NetworkSuccessHandler) {
        
        if let errorDict = response?["error"] as? [String: Any] {
//           let error = IMError(errorDict: errorDict) {
//            errorHandler(error)
        } else {
            successHandler(response)
        }
    }

    class func parseResponse(_ response: DataResponse<Any>,
                             successHandler: @escaping NetworkSuccessHandler,
                             errorHandler: @escaping NetworkErrorHandler) {
        
        if response.result.isSuccess {
            if  let data = response.result.value as? [String: AnyObject] {
                print("Response url processing... \(String(describing: response.response?.url))")
                BaseNetworkService.handleResponseData(data, errorHandler: errorHandler, successHandler: successHandler)
            } else if let data = response.result.value as? [[String: AnyObject]] {
                BaseNetworkService.handleResponseData(["data": data], errorHandler: errorHandler, successHandler: successHandler)
            } else {
                BaseNetworkService.handleResponseData(nil, errorHandler: errorHandler, successHandler: successHandler)
            }
        } else {
            // TODO: - Handle error
        }
    }

    class func sendRequest(_ method: HTTPMethod,
                           request: String,
                           successHandler: @escaping NetworkSuccessHandler,
                           errorHandler: @escaping NetworkErrorHandler) {
        
        let url = "\(BaseNetworkService.baseUrl)/\(request)"
        let request = BaseNetworkService.alamofireManager.request(url, method: method)
        request.validate(statusCode: 200..<300).responseJSON { response in
            parseResponse(response,
                          successHandler: successHandler,
                          errorHandler: errorHandler)
        }
    }

    class func downloadImage(from imageURLString: String,
                             successHandler: @escaping NetworkSuccessHandler,
                             errorHandler: @escaping NetworkErrorHandler,
                             progressHandler: @escaping NetworkProgressHandler) -> DataRequest {
        
        let request = Alamofire.request(imageURLString)
        request.downloadProgress {
            progressHandler($0.fractionCompleted)
        }
        request.responseImage { response in
            if let image = response.result.value {
                successHandler(["image": image])
            } else {
//                errorHandler(IMError.unknownError())
            }
        }
        
        print("request = \(request)")
        return request
    }

    class func cancelAllRequestsToPath(_ method: HTTPMethod?, path: String?) {
        BaseNetworkService.alamofireManager.session.getAllTasks { tasks in
            tasks.forEach { task in
                if let relativePath = task.originalRequest?.url?.relativePath {
                    let trimmedPath = relativePath.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
                    if path != nil && trimmedPath != path! {
                        return
                    }
                }

                if method != nil && task.originalRequest?.httpMethod != method?.rawValue {
                    return
                }

                task.cancel()
            }
        }
    }
}
