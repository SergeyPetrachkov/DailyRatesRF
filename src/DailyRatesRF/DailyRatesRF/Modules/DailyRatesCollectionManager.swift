//
//  DailyRatesCollectionManager.swift
//  DailyRatesRF
//
//  Created by sergey on 16.03.2020.
//  Copyright © 2020 West Coast IT. All rights reserved.
//

import UIKit
import Jormungandr

class DailyRatesDisplayManager: SiberianCollectionViewManager, UICollectionViewDragDelegate, UICollectionViewDropDelegate {

  func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    guard let destinationIndexPath = coordinator.destinationIndexPath else {
      return
    }

    coordinator.items.forEach { dropItem in
      guard let sourceIndexPath = dropItem.sourceIndexPath else {
        return
      }

      collectionView.performBatchUpdates({
        (self.provider as? CollectionPresenter)?.reorder(oldIndexPath: sourceIndexPath, newIndexPath: destinationIndexPath)
        collectionView.deleteItems(at: [sourceIndexPath])
        collectionView.insertItems(at: [destinationIndexPath])
      }, completion: { _ in
        coordinator.drop(dropItem.dragItem,
                         toItemAt: destinationIndexPath)
      })
    }
  }

  func collectionView(_ collectionView: UICollectionView,
                      dropSessionDidUpdate session: UIDropSession,
                      withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
      return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
  }

  func collectionView(_ collectionView: UICollectionView,
                      itemsForBeginning session: UIDragSession,
                      at indexPath: IndexPath) -> [UIDragItem] {
    guard let item = self.provider.item(for: indexPath) else {
      return []
    }
    let nsItem = NSItemProvider(object: item as! NSItemProviderWriting)
    let dragItem = UIDragItem(itemProvider: nsItem)
    return [dragItem]
  }


  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 2
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 2
  }

  override func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.width - 20, height: 100)
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
  }
}
