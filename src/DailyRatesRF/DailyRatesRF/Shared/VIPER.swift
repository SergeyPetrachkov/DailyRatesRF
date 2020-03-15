//
//  VIPER.swift
//  DailyRatesRF
//
//  Created by sergey on 15.03.2020.
//  Copyright © 2020 West Coast IT. All rights reserved.
//

import UIKit
import Jormungandr

protocol GenericPresenter: GenericInteractorOutput {
  associatedtype ModuleIn: IModuleIn
  associatedtype View
  associatedtype ViewOutput
  associatedtype Interactor: GenericInteractor
  associatedtype Router
  associatedtype ViewModel

  init(moduleIn: IModuleIn)

  var view: View! { get set }
  var output: ViewOutput? { get set }

  var interactor: Interactor { get set }
  var router: Router { get set }
  var viewModel: ViewModel { get set }

}

protocol GenericInteractorOutput: AnyObject {

}

protocol GenericInteractor: AnyObject {
  associatedtype InteractorOutput
  var output: InteractorOutput? { get set }
}

protocol IModuleIn { }

protocol IView: AnyObject {
  associatedtype Presenter: GenericPresenter

  init(moduleIn: IModuleIn)

  var presenter: Presenter? { get set }
}

protocol ModuleAssembly {
  associatedtype ModuleIn: IModuleIn
  associatedtype View: IView
  associatedtype Presenter: GenericPresenter
  associatedtype Interactor: GenericInteractor
  associatedtype Router

  func createModule(moduleIn: IModuleIn) -> View

  func injectPresenter(moduleIn: IModuleIn) -> Presenter

  func injectInteractor() -> Interactor

  func injectRouter() -> Router
}

extension ModuleAssembly {
  func createModule(moduleIn: IModuleIn) -> View {
    let module = View.init(moduleIn: moduleIn)
    let presenter = injectPresenter(moduleIn: moduleIn)
    module.presenter = presenter as? Self.View.Presenter
    presenter.output = module as? Self.Presenter.ViewOutput
    return module
  }

  func injectPresenter(moduleIn: IModuleIn) -> Presenter {
    let presenter = Presenter.init(moduleIn: moduleIn)
    let interactor = injectInteractor() as! Self.Presenter.Interactor
    presenter.interactor = interactor
    interactor.output = presenter as? Self.Presenter.Interactor.InteractorOutput
    presenter.router = injectRouter() as! Self.Presenter.Router
    return presenter
  }
}

