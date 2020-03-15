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
  func didReceive(rates: String)
  func didFail(with error: Error)
}

final class CustomSplashInteractor: CustomSplashInteractorInput {
  let queue = DispatchQueue(label: String(describing: CustomSplashInteractor.self))
  weak var output: CustomSplashInteractorOutput?

  func fetchRates() {
    self.queue.async {
      API.init().fetchDailyRates { result in
        DispatchQueue.main.async {
          switch result {
          case .success(let rates):
            self.output?.didReceive(rates: String(describing:rates))
          case .failure(let error):
            self.output?.didFail(with: error)
          }
        }
      }
    }
  }
}
