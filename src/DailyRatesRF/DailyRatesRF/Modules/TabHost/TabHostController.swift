//
//  TabHostController.swift
//  DailyRatesRF
//
//  Created by sergey on 21.03.2020.
//  Copyright © 2020 West Coast IT. All rights reserved.
//

import UIKit

final class TabHostController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    Yahoo().fetchCrudeOil { result in
      print(result)
    }
  }
}
