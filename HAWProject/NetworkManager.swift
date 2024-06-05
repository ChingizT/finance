import Foundation

class NetworkManager {
   
static let shared = NetworkManager()
   
    func getExchangeData(completion: @escaping (ExchangeData?) -> Void) {
        let url = URL(string: "https://open.er-api.com/v6/latest/USD")!
        
        let manager = URLSession.shared

            manager.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    print(error)
                    completion(nil)
                    return
                }
                guard let data = data else {
                    completion(nil)
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let exchangeData = try decoder.decode(ExchangeData.self, from: data)
                    completion(exchangeData)

                } catch(let error) {
                    print(error)
                    completion(nil)
                    return
                }
                
            }.resume()
    }
    
}

struct ExchangeData: Codable {
       let result: String
        let provider, documentation, termsOfUse: String
        let timeLastUpdateUnix: Int
        let timeLastUpdateUTC: String
        let timeNextUpdateUnix: Int
        let timeNextUpdateUTC: String
        let timeEOLUnix: Int
        let baseCode: String
        let rates: [String: Double]

        enum CodingKeys: String, CodingKey {
           case result, provider, documentation
            case termsOfUse = "terms_of_use"
            case timeLastUpdateUnix = "time_last_update_unix"
            case timeLastUpdateUTC = "time_last_update_utc"
            case timeNextUpdateUnix = "time_next_update_unix"
            case timeNextUpdateUTC = "time_next_update_utc"
            case timeEOLUnix = "time_eol_unix"
            case baseCode = "base_code"
            case rates
        }
    }
