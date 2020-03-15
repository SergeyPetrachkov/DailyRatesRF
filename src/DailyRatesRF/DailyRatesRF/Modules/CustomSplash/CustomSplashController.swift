//
//  CustomSplashController.swift
//  DailyRatesRF
//
//  Created by sergey on 15.03.2020.
//  Copyright © 2020 West Coast IT. All rights reserved.
//

import UIKit

final class CustomSplashController: UIViewController {
  let textLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()

  var presenter: CustomSplashPresenterInput?

  init(moduleIn: IModuleIn) {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .green
    self.view.addSubview(self.textLabel)
    self.presenter?.start()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
//    let constraints = [
////      self.textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
////      self.textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//      self.textLabel.widthAnchor.constraint(equalToConstant: 200),
//      self.textLabel.heightAnchor.constraint(equalTo: view.heightAnchor)
//    ]
//    NSLayoutConstraint.activate(constraints)
    self.textLabel.frame = self.view.bounds
  }
}

extension CustomSplashController: CustomSplashPresenterOutput {
  func didChange(_ viewModel: CustomSplash.ViewModel) {
    self.textLabel.text = viewModel.stringRates
    self.view.setNeedsLayout()
  }
}
