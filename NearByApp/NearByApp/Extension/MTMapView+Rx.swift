//
//  MTMapView+Rx.swift
//  NearByApp
//
//  Created by miori Lee on 2022/01/29.
//

import Foundation
import RxSwift
import RxCocoa

/*
 - custom extension :  객체.rx.함수접근이 가능하게끔 표현
 */
extension Reactive where Base : MTMapView {
    //Binder : ObserverType을 따름. 값을 주입시킬 수는 있지만, 값을 관찰할 수는 없음.
    //ObserverType : 값을 주입(Inject)시킬 수 있는 타입
   // ObservableType : 값을 관찰할 수 있는 타입
    var setMapCenterPoint : Binder<MTMapPoint> {
        return Binder(base) { base, point in
            base.setMapCenter(point, animated: true)
        }
    }
}

