//
//  CustomSplashInteractor.swift
//  DailyRatesRF
//
//  Created by sergey on 15.03.2020.
//  Copyright © 2020 West Coast IT. All rights reserved.
//

import Foundation

protocol CustomSplashInteractorInput: AnyObject {
  var output: CustomSplashInteractorOutput? { get set }
  func fetchRates()
}

protocol CustomSplashInteractorOutput: AnyObject {
  func didReceive(response: CustomSplash.FetchResponse)
  func didFail(with error: Error)
}

final class CustomSplashInteractor: CustomSplashInteractorInput {
  let queue = DispatchQueue(label: String(describing: CustomSplashInteractor.self))
  let repository = DailyRatesRepository()
  weak var output: CustomSplashInteractorOutput?

  func fetchRates() {
    self.queue.async {
      do {
        let rates = try self.repository.fetch()
        let viewModels = rates
          .map { CurrencyItemModel(dataContext: CurrencyViewModel(dataContext: $0)) }
          .sorted(by: { $0.id < $1.id } )
        DispatchQueue.main.async {
          self.output?.didReceive(response: CustomSplash.FetchResponse(items: viewModels))
        }
      } catch {
        DispatchQueue.main.async {
          self.output?.didFail(with: error)
        }
      }
    }
  }
}
