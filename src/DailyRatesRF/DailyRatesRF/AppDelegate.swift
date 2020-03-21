//
//  AppDelegate.swift
//  DailyRatesRF
//
//  Created by sergey on 15.03.2020.
//  Copyright © 2020 West Coast IT. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    let tabHost = TabHostController()
    tabHost.viewControllers = [
      UINavigationController(
        rootViewController: RatesFeedAssembly().createModule(moduleIn: RatesFeed.ModuleIn(title: "ЦБ РФ"))
      )
    ]
    let root =  tabHost
    self.window?.rootViewController = root
    self.window?.makeKeyAndVisible()
    return true
  }
}

