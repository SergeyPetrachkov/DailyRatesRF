//
//  Yahoo.swift
//  DailyRatesRF
//
//  Created by sergey on 21.03.2020.
//  Copyright © 2020 West Coast IT. All rights reserved.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let yahooRate = try? newJSONDecoder().decode(YahooRate.self, from: jsonData)

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseYahooRate { response in
//     if let yahooRate = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - YahooRate
struct YahooRate: Codable {
  let chart: Chart
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseChart { response in
//     if let chart = response.result.value {
//       ...
//     }
//   }

// MARK: - Chart
struct Chart: Codable {
  var result: [YahooResult] = []
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseYahooResult { response in
//     if let yahooResult = response.result.value {
//       ...
//     }
//   }

// MARK: - YahooResult
struct YahooResult: Codable {
  let meta: Meta
  let timestamp: [Int]
  let indicators: Indicators
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseIndicators { response in
//     if let indicators = response.result.value {
//       ...
//     }
//   }

// MARK: - Indicators
struct Indicators: Codable {
  let quote: [Quote]
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseQuote { response in
//     if let quote = response.result.value {
//       ...
//     }
//   }

// MARK: - Quote
struct Quote: Codable {
  let high, close, quoteOpen: [Double?]
  let volume: [Int?]
  let low: [Double?]

  enum CodingKeys: String, CodingKey {
    case high, close
    case quoteOpen = "open"
    case volume, low
  }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseMeta { response in
//     if let meta = response.result.value {
//       ...
//     }
//   }

// MARK: - Meta
struct Meta: Codable {
  let currency, symbol, exchangeName, instrumentType: String
  let firstTradeDate, regularMarketTime, gmtoffset: Int
  let timezone, exchangeTimezoneName: String
  let regularMarketPrice, chartPreviousClose, previousClose: Double
  let scale, priceHint: Int
  let currentTradingPeriod: CurrentTradingPeriod
  let tradingPeriods: [[Post]]
  let dataGranularity, range: String
  let validRanges: [String]
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseCurrentTradingPeriod { response in
//     if let currentTradingPeriod = response.result.value {
//       ...
//     }
//   }

// MARK: - CurrentTradingPeriod
struct CurrentTradingPeriod: Codable {
  let pre, regular, post: Post
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responsePost { response in
//     if let post = response.result.value {
//       ...
//     }
//   }

// MARK: - Post
struct Post: Codable {
  let timezone: String
  let start, end, gmtoffset: Int
}


final class Yahoo {
  func fetchCrudeOil(completion: @escaping (Result<YahooRate, AFError>) -> Void) {
    AF.request(
      URL(
        string: "https://query1.finance.yahoo.com/v8/finance/chart/CLJ20.NYM?region=US&lang=en-US&includePrePost=false&interval=2m&range=1d&corsDomain=finance.yahoo.com&.tsrc=finance"
        )!
    ).responseDecodable { (response: DataResponse<YahooRate, AFError>) in
        completion(response.result)
    }
  }
}
