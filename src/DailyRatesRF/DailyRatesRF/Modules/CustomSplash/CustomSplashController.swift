//
//  CustomSplashController.swift
//  DailyRatesRF
//
//  Created by sergey on 15.03.2020.
//  Copyright © 2020 West Coast IT. All rights reserved.
//

import UIKit
import SnapKit
import Jormungandr

final class CustomSplashController: UIViewController {

  private let collectionView: UICollectionView = UICollectionView(frame: .zero,
                                                                  collectionViewLayout: UICollectionViewFlowLayout())
  private let refreshControl = UIRefreshControl()

  lazy var displayManager: SiberianCollectionViewManager? = { [weak self] in
    guard let strongSelf = self,
      let provider = strongSelf.presenter as? CollectionSource else {
        return nil
    }
    let manager = DailyRatesDisplayManager(provider: provider,
                                           delegate: nil,
                                           fetchDelegate: nil,
                                           scrollDirection: .vertical)
    strongSelf.collectionView.delegate = manager
    return manager
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
    self.view.backgroundColor = .secondarySystemBackground
    self.view.addSubview(self.collectionView)
    self.collectionView.dataSource = self.displayManager
    self.collectionView.backgroundColor = .secondarySystemBackground
    self.view.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints { make in
      make.edges.equalTo(self.view.safeAreaLayoutGuide)
    }
    CurrencyItemModel.registerIn(self.collectionView)
    self.collectionView.alwaysBounceVertical = true
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.YYYY"
    self.title = dateFormatter.string(from: Date())
    self.presenter?.start()
    self.refreshControl.addTarget(self, action: #selector(self.didPullToRefresh), for: .valueChanged)
    self.collectionView.refreshControl = self.refreshControl
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  @objc
  private func didPullToRefresh() {
    try? self.presenter?.fetchItems(reset: true)
  }
}

extension CustomSplashController: CustomSplashPresenterOutput {
  func didChange(_ viewModel: CustomSplash.ViewModel) {
    if self.refreshControl.isRefreshing {
      self.refreshControl.endRefreshing()
    }
    self.collectionView.reloadData()
  }
}
