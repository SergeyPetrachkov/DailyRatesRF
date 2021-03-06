// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dailyRates = try? newJSONDecoder().decode(DailyRates.self, from: jsonData)

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseDailyRates { response in
//     if let dailyRates = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - DailyRates
struct DailyRates: Codable {
  let date, previousDate: String
  let previousURL: String
  let timestamp: String
  let valute: [String: CBCurrencyDto]

  enum CodingKeys: String, CodingKey {
    case date = "Date"
    case previousDate = "PreviousDate"
    case previousURL = "PreviousURL"
    case timestamp = "Timestamp"
    case valute = "Valute"
  }
}

// MARK: - Valute
struct CBCurrencyDto: Codable {
  let id, numCode, charCode: String
  let nominal: Int
  let name: String
  let value, previous: Double

  enum CodingKeys: String, CodingKey {
    case id = "ID"
    case numCode = "NumCode"
    case charCode = "CharCode"
    case nominal = "Nominal"
    case name = "Name"
    case value = "Value"
    case previous = "Previous"
  }
}

final class API {
  func fetchDailyRates(completion: @escaping (Result<DailyRates, AFError>) -> Void) {
      AF.request(URL(string: "https://www.cbr-xml-daily.ru/daily_json.js")!)
      .responseDecodable { (response: DataResponse<DailyRates, AFError>) in
        completion(response.result)
    }
  }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
  let decoder = JSONDecoder()
  if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
    decoder.dateDecodingStrategy = .iso8601
  }
  return decoder
}

func newJSONEncoder() -> JSONEncoder {
  let encoder = JSONEncoder()
  if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
    encoder.dateEncodingStrategy = .iso8601
  }
  return encoder
}
