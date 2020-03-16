//
//  CustomSplashPresenter.swift
//  DailyRatesRF
//
//  Created by sergey on 15.03.2020.
//  Copyright © 2020 West Coast IT. All rights reserved.
//

import Foundation
import SiberianSwift
import Jormungandr

protocol CustomSplashPresenterInput: ModuleLifecycle, CollectionPresenterInput {
  var view: CustomSplashController! { get set }
  var viewModel: CustomSplash.ViewModel { get set }
  var output: CustomSplashPresenterOutput? { get set }
  var interactor: CustomSplashInteractorInput? { get set }
  var router: CustomSplashRouterInput? { get set }
}

protocol CustomSplashPresenterOutput: AnyObject {
  func didChange(_ viewModel: CustomSplash.ViewModel)
}

final class CustomSplashPresenter: CollectionPresenter, CustomSplashPresenterInput {
  weak var view: CustomSplashController!

  weak var output: CustomSplashPresenterOutput?

  var interactor: CustomSplashInteractorInput?

  var router: CustomSplashRouterInput?

  var viewModel: CustomSplash.ViewModel

  init(moduleIn: CustomSplash.ModuleIn) {
    self.viewModel = CustomSplash.ViewModel()
    super.init(collectionModel: self.viewModel)
  }

  func start() {
    self.interactor?.fetchRates()
  }
  func stop() {

  }
  func resume() {

  }
}

extension CustomSplashPresenter: CustomSplashInteractorOutput {
  func didReceive(response: CustomSplash.FetchResponse) {
    self.viewModel.items = response.items
    self.output?.didChange(self.viewModel)
  }

  func didFail(with error: Error) {
    self.view.showToast(with: error.localizedDescription)
  }
}
