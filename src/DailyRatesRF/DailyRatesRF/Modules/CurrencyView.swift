//
//  CurrencyView.swift
//  DailyRatesRF
//
//  Created by sergey on 16.03.2020.
//  Copyright © 2020 West Coast IT. All rights reserved.
//

import UIKit
import Jormungandr

protocol ICurrencyValue {
  var id: String { get }
  var title: String { get }
  var nominal: Int { get }
  var currentRate: Double { get }
  var previousRate: Double { get }
}

struct CurrencyValue: ICurrencyValue {
  let id: String
  let title: String
  let nominal: Int
  let currentRate: Double
  let previousRate: Double
}

struct CurrencyViewModel {
  let id: String
  let title: String
  let currentRate: Double
  let previousRate: Double
  let nominal: Int

  init(dataContext: ICurrencyValue) {
    self.id = dataContext.id
    self.title = dataContext.title
    self.currentRate = dataContext.currentRate
    self.previousRate = dataContext.previousRate
    self.nominal = dataContext.nominal
  }
}

final class CurrencyView: UIControl {

  var viewModel: ICurrencyValue! {
    didSet {
      guard let viewModel = self.viewModel else {
        return
      }
      self.titleLabel.text = viewModel.title
      self.rateLabel.text = "\(viewModel.currentRate) рублей"
      self.setNeedsLayout()
    }
  }

  private let titleLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    label.numberOfLines = 0
    return label
  }()

  private let rateLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.font = UIFont.systemFont(ofSize: 24, weight: .light)
    return label
  }()

  override init(frame: CGRect = .zero) {
    super.init(frame: frame)
    self.addSubview(self.titleLabel)
    self.addSubview(self.rateLabel)
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalTo(self).offset(20)
      make.left.equalTo(self).offset(20)
      make.bottom.equalTo(self.rateLabel).offset(-20)
      make.right.equalTo(self).offset(-20)
    }
    self.rateLabel.snp.makeConstraints { make in
      make.top.equalTo(self.titleLabel).offset(20)
      make.left.equalTo(self).offset(20)
      make.bottom.equalTo(self).offset(-20)
      make.right.equalTo(self).offset(-20)
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

struct CurrencyItemModel: GenericCollectionItemPresenter, ICurrencyValue {
  var id: String {
    self.dataContext.id
  }

  var title: String {
    "\(self.dataContext.nominal) \(self.dataContext.title)"
  }

  var nominal: Int {
    self.dataContext.nominal
  }

  var currentRate: Double {
    self.dataContext.currentRate
  }

  var previousRate: Double {
    self.dataContext.previousRate
  }

  typealias ViewType = CurrencyCell

  static var anyViewType: UIView.Type {
    return CurrencyCell.self
  }

  let dataContext: CurrencyViewModel

  func setup(view: CurrencyCell) {
    view.viewModel = self
  }
}

final class CurrencyCell: UICollectionViewCell {

  var viewModel: CurrencyItemModel! {
    didSet {
      self.currencyView.viewModel = viewModel
    }
  }

  let currencyView: CurrencyView = CurrencyView(frame: .zero)

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(self.currencyView)
    self.currencyView.snp.makeConstraints { make in
      make.edges.equalTo(self).inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
    self.currencyView.layer.cornerRadius = 5
    self.currencyView.clipsToBounds = true
    self.currencyView.shadowOffset = CGPoint(x: 0, y: 1)
    self.currencyView.shadowRadius = 3
    self.currencyView.shadowColor = .gray
    self.currencyView.shadowOpacity = 0.5
    self.currencyView.masksLayerToBounds = true
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
