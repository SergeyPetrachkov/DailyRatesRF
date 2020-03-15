//
//  CustomSplashAssembly.swift
//  DailyRatesRF
//
//  Created by sergey on 15.03.2020.
//  Copyright © 2020 West Coast IT. All rights reserved.
//

import Jormungandr

final class CustomSplashAssembly: IModuleAssembly {
  func createModule(moduleIn: CustomSplash.ModuleIn = CustomSplash.ModuleIn()) -> CustomSplashController {
    let module = CustomSplashController(moduleIn: moduleIn)
    let presenter = injectPresenter(moduleIn: moduleIn)
    presenter.view = module
    module.presenter = presenter
    presenter.output = module
    return module
  }

  func injectPresenter(moduleIn: CustomSplash.ModuleIn) -> CustomSplashPresenterInput {
    let presenter = CustomSplashPresenter(moduleIn: moduleIn)
    let interactor = injectInteractor()
    presenter.interactor = interactor
    interactor.output = presenter
    presenter.router = injectRouter()
    return presenter
  }

  func injectInteractor() -> CustomSplashInteractorInput {
    return CustomSplashInteractor()
  }

  func injectRouter() -> CustomSplashRouterInput {
    return CustomSplashRouter()
  }
}
