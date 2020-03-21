//
//  RatesFeedPresenter.swift
//  DailyRatesRF
//
//  Created by sergey on 15.03.2020.
//  Copyright © 2020 West Coast IT. All rights reserved.
//

import Foundation
import SiberianSwift
import Jormungandr

protocol RatesFeedPresenterInput: ModuleLifecycle, CollectionPresenterInput {
  var view: RatesFeedController! { get set }
  var viewModel: RatesFeed.ViewModel { get set }
  var output: RatesFeedPresenterOutput? { get set }
  var interactor: RatesFeedInteractorInput? { get set }
  var router: RatesFeedRouterInput? { get set }
}

protocol RatesFeedPresenterOutput: AnyObject {
  func didChange(_ viewModel: RatesFeed.ViewModel)
}

final class RatesFeedPresenter: CollectionPresenter, RatesFeedPresenterInput {
  weak var view: RatesFeedController!

  weak var output: RatesFeedPresenterOutput?

  var interactor: RatesFeedInteractorInput?

  var router: RatesFeedRouterInput?

  var viewModel: RatesFeed.ViewModel

  init(moduleIn: RatesFeed.ModuleIn) {
    self.viewModel = RatesFeed.ViewModel()
    super.init(collectionModel: self.viewModel)
  }

  func start() {
    try? self.fetchItems(reset: true)
  }

  func stop() {

  }

  func resume() {

  }

  override func fetchItems(reset: Bool) throws {
    try super.fetchItems(reset: reset)
    self.interactor?.fetchRates()
  }

  override func reorder(oldIndexPath: IndexPath, newIndexPath: IndexPath) {
    super.reorder(oldIndexPath: oldIndexPath, newIndexPath: newIndexPath)
    self.interactor?.saveOrder(ids: (self.viewModel.items as? [CurrencyItemModel])?.compactMap { $0.id } ?? [])
  }
}

extension RatesFeedPresenter: RatesFeedInteractorOutput {
  func didReceive(response: RatesFeed.FetchResponse) {
    self.viewModel.items = response.items
    self.output?.didChange(self.viewModel)
  }

  func didFail(with error: Error) {
    self.view.showToast(with: error.localizedDescription)
  }
}

extension CollectionPresenter {
  @objc
  func reorder(oldIndexPath: IndexPath, newIndexPath: IndexPath) {
    self.collectionModel.items.swapAt(oldIndexPath.row, newIndexPath.row)
  }
}
