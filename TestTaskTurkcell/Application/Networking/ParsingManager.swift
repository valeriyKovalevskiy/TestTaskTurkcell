import Foundation

class ParsingManager {
    static let shared = ParsingManager()

    func parse<T: Codable>(from response: [String: Any]?, completion: @escaping ([T]) -> Void) {
        do {
            guard let response = response else { return }
            guard let jsonData = try? JSONSerialization.data(withJSONObject: response) else { return }

            let decoded = try JSONDecoder().decode([T].self, from: jsonData)
            completion(decoded)
        } catch let error {

            print(error.localizedDescription)
//            ProgressManager.shared.dismissWithError("Could't fetch data from networking")
        }
    }

}

