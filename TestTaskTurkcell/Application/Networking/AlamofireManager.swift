import Foundation
import Alamofire

public class AlamofireManager: Alamofire.SessionManager {
    
    override open func request(_ url: URLConvertible,
                               method: HTTPMethod = .get,
                               parameters: Parameters? = nil,
                               encoding: ParameterEncoding = JSONEncoding.default,
                               headers: HTTPHeaders? = nil) -> DataRequest {
        
        let fullParameters = parameters ?? [:]
        if method == .get {
            return super.request(url, method: method, parameters: fullParameters, encoding: URLEncoding.default)
        }
        return super.request(url, method: method, parameters: fullParameters, encoding: encoding)
    }
}
