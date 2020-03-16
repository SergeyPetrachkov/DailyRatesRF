//
//  DailyRatesCollectionManager.swift
//  DailyRatesRF
//
//  Created by sergey on 16.03.2020.
//  Copyright © 2020 West Coast IT. All rights reserved.
//

import UIKit
import Jormungandr

class DailyRatesDisplayManager: SiberianCollectionViewManager {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 4
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 4
  }

  override func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.width - 20, height: 100)
  }
}
