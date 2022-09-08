//
//  LocationInfoViewController+Rx.swift
//  NearByApp
//
//  Created by miori Lee on 2022/01/31.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base : LocationInfoViewController {
    
    var showSelectedLocation : Binder<Int> {
        return Binder(base) {base, row in
            let indexPath = IndexPath(row: row, section: 0)
            base.detailList.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        }
    }
    
    var addPOIItemRx : Binder<[MTMapPoint]> {
        return Binder(base) { base, points in
            let items = points
                .enumerated()
                .map { offset, point -> MTMapPOIItem in
                    let mapPOIItem = MTMapPOIItem()
                    //지도상 좌표
                    mapPOIItem.mapPoint = point
                    mapPOIItem.customImage = UIImage(systemName: "figure.walk.circle.fill")
                    mapPOIItem.markerType = .customImage
                    mapPOIItem.showAnimationType = .springFromGround
                    mapPOIItem.tag = offset
                    return mapPOIItem
                }
            base.mapView.removeAllPOIItems()
            base.mapView.addPOIItems(items)
        }
    }
}

