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

extension ICurrencyValue {
  var difference: Double {
    currentRate - previousRate
  }

  var isPositiveTrend: Bool {
    difference >= 0
  }

  var formattedDifference: String {
    "\(isPositiveTrend ? "+" : "")\(String(format: "%.2f", difference))"
  }
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

  private struct Configurator {
    let offset: CGFloat

    static var `default`: Configurator {
      return .init(offset: 10)
    }
  }

  var viewModel: ICurrencyValue! {
    didSet {
      guard let viewModel = self.viewModel else {
        return
      }
      self.titleLabel.text = viewModel.title
      self.rateLabel.text = "\(viewModel.currentRate) рублей"
      self.diffLabel.text = viewModel.formattedDifference
      self.diffLabel.textColor = viewModel.isPositiveTrend ? .green : .red
      self.setNeedsLayout()
    }
  }

  private let titleLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    label.numberOfLines = 0
    label.isOpaque = true
    return label
  }()

  private let rateLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.font = UIFont.systemFont(ofSize: 22, weight: .light)
    label.isOpaque = true
    return label
  }()

  private let diffLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.font = UIFont.systemFont(ofSize: 14, weight: .light)
    label.isOpaque = true
    return label
  }()

  override var backgroundColor: UIColor? {
    didSet {
      self.titleLabel.backgroundColor = self.backgroundColor
      self.rateLabel.backgroundColor = self.backgroundColor
      self.diffLabel.backgroundColor = self.backgroundColor
    }
  }

  override init(frame: CGRect = .zero) {
    super.init(frame: frame)
    self.addSubview(self.titleLabel)
    self.addSubview(self.rateLabel)
    self.addSubview(self.diffLabel)
    self.isOpaque = true
    let offset = Configurator.default.offset

    self.titleLabel.snp.makeConstraints { make in
      make.top.equalTo(self).offset(offset)
      make.left.equalTo(self).offset(offset)
      make.right.equalTo(self).offset(-offset)
    }
    self.rateLabel.snp.makeConstraints { make in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(offset/2)
      make.left.equalTo(self).offset(offset)
      make.bottom.equalTo(self).offset(-offset)
//      make.right.equalTo(self).offset(-offset)
    }

    self.diffLabel.snp.makeConstraints { make in
      make.centerY.equalTo(self.rateLabel.snp.centerY)
      make.left.equalTo(self.rateLabel.snp.right).offset(offset)
      make.bottom.equalTo(self).offset(-offset)
      make.right.equalTo(self).offset(-offset)
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
//    self.currencyView.clipsToBounds = true
    self.currencyView.shadowOffset = CGPoint(x: 0, y: 1)
    self.currencyView.shadowRadius = 3
    self.currencyView.shadowColor = .gray
    self.currencyView.shadowOpacity = 0.5
    self.currencyView.backgroundColor = .tertiarySystemBackground
    self.currencyView.masksLayerToBounds = true
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
