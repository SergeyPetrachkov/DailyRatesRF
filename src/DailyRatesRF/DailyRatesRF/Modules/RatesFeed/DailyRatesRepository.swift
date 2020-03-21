//
//  DailyRatesRepository.swift
//  DailyRatesRF
//
//  Created by sergey on 16.03.2020.
//  Copyright © 2020 West Coast IT. All rights reserved.
//

import Foundation

final class DailyRatesRepository {
  func fetch() throws -> [CurrencyValue] {
    var output: [CurrencyValue] = []
    var resultingError: Error?
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    API().fetchDailyRates { result in
      switch result {
      case .success(let rates):
        output = rates.valute.values.map { value in
          return CurrencyValue(id: value.id,
                               title: value.name,
                               nominal: value.nominal,
                               currentRate: value.value,
                               previousRate: value.previous)
        }
      case .failure(let error):
        resultingError = error
      }
      dispatchGroup.leave()
    }
    dispatchGroup.wait()
    if let error = resultingError {
      throw error
    }
    return output
  }
}

final class RatesOrderRepository {
  typealias CurrencyId = String

  @UserDefault("ratesOrder", defaultValue: [])
  var order: [CurrencyId]
}
