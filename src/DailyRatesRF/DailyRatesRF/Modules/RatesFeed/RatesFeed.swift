//
//  RatesFeedAssembly.swift
//  DailyRatesRF
//
//  Created by sergey on 15.03.2020.
//  Copyright © 2020 West Coast IT. All rights reserved.
//

import Jormungandr

final class RatesFeedAssembly: IModuleAssembly {
  func createModule(moduleIn: RatesFeed.ModuleIn) -> RatesFeedController {
    let module = RatesFeedController(moduleIn: moduleIn)
    let presenter = injectPresenter(moduleIn: moduleIn)
    presenter.view = module
    module.presenter = presenter
    presenter.output = module
    return module
  }

  func injectPresenter(moduleIn: RatesFeed.ModuleIn) -> RatesFeedPresenterInput {
    let presenter = RatesFeedPresenter(moduleIn: moduleIn)
    let interactor = injectInteractor()
    presenter.interactor = interactor
    interactor.output = presenter
    presenter.router = injectRouter()
    return presenter
  }

  func injectInteractor() -> RatesFeedInteractorInput {
    return RatesFeedInteractor()
  }

  func injectRouter() -> RatesFeedRouterInput {
    return RatesFeedRouter()
  }
}
