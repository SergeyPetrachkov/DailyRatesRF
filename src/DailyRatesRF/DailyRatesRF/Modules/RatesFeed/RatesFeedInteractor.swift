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
  func saveOrder(ids: [String])
}

protocol RatesFeedInteractorOutput: AnyObject {
  func didReceive(response: RatesFeed.FetchResponse)
  func didFail(with error: Error)
}

final class RatesFeedInteractor: RatesFeedInteractorInput {
  let queue = DispatchQueue(label: String(describing: RatesFeedInteractor.self))

  let repository = DailyRatesRepository()
  let orderPersistence = RatesOrderRepository()

  weak var output: RatesFeedInteractorOutput?

  func fetchRates() {
    self.queue.async {
      do {
        let rates = try self.repository.fetch()
        let order = self.orderPersistence.order
        if order.isEmpty {
          self.orderPersistence.order = rates.sorted(by: { $0.id < $1.id } ).compactMap { $0.id }
        }
        let sortedRates = rates.sorted(by: {
          if let lastMatchingIndexFromSelectedOrder = order.lastIndex(of: $0.id),
            let lastMatchingNextIndexFromSelectedOrder =  order.lastIndex(of: $1.id) {
            return lastMatchingIndexFromSelectedOrder < lastMatchingNextIndexFromSelectedOrder
          } else {
            return true
          }
        })
        let viewModels = sortedRates
          .map { CurrencyItemModel(dataContext: CurrencyViewModel(dataContext: $0)) }

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

  func saveOrder(ids: [String]) {
    self.orderPersistence.order = ids
  }
}
