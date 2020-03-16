//
//  CustomSplashEntities.swift
//  DailyRatesRF
//
//  Created by sergey on 15.03.2020.
//  Copyright © 2020 West Coast IT. All rights reserved.
//

import Jormungandr

enum CustomSplash {
  struct ModuleIn: IModuleIn {

  }

  struct FetchResponse {
    let items: [CollectionItemPresenter]
  }

  final class ViewModel: CollectionViewModel {
    var pendingState: PendingState?

    var batchSize: Int = 0

    var items: [CollectionItemPresenter] = []

    var changeSet: [CollectionDelta] = []

    var stringRates: String = ""
  }
}
