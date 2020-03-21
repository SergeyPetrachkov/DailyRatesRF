//
//  CustomSplashInteractor.swift
//  DailyRatesRF
//
//  Created by sergey on 15.03.2020.
//  Copyright © 2020 West Coast IT. All rights reserved.
//

import Foundation

protocol RatesFeedInteractorInput: AnyObject {
  var output: RatesFeedInteractorOutput? { get set }
  func fetchRates()
}

protocol RatesFeedInteractorOutput: AnyObject {
  func didReceive(response: RatesFeed.FetchResponse)
  func didFail(with error: Error)
}

final class RatesFeedInteractor: RatesFeedInteractorInput {
  let queue = DispatchQueue(label: String(describing: RatesFeedInteractor.self))
  let repository = DailyRatesRepository()
  weak var output: RatesFeedInteractorOutput?

  func fetchRates() {
    self.queue.async {
      do {
        let rates = try self.repository.fetch()
        let viewModels = rates
          .map { CurrencyItemModel(dataContext: CurrencyViewModel(dataContext: $0)) }
          .sorted(by: { $0.id < $1.id } )
        DispatchQueue.main.async {
          self.output?.didReceive(response: RatesFeed.FetchResponse(items: viewModels))
        }
      } catch {
        DispatchQueue.main.async {
          self.output?.didFail(with: error)
        }
      }
    }
  }
}
