//
//  LocationInfoViewModel.swift
//  NearByApp
//
//  Created by miori Lee on 2022/01/26.
//

import Foundation
import RxCocoa
import RxSwift

struct LocationInfoViewModel {
    let disposeBag = DisposeBag()
    
    // viewModel -> view
    
    //Driver는 BehaviorRelay, Signal은 PublishRelay와 많은 공통점
    
    // 센터로
    let setMapCenter : Signal<MTMapPoint>
    let errorMessage : Signal<String>
    
    // view -> viewModel
    let currentLocation = PublishRelay<MTMapPoint>()
    let mapCenterPoint = PublishRelay<MTMapPoint>()
    let selectPOIItem = PublishRelay<MTMapPOIItem>()
    let mapViewError =  PublishRelay<String>()
    let currentLocationBtnTapped = PublishRelay<Void>()
    
    init() {
        //MARK: 지도의 중심점 선택
        let moveToCurrentLocation = currentLocationBtnTapped
            // 현재위치 한번이라도 받은 이후에
            .withLatestFrom(currentLocation)
        
        let currentMapCenter  = Observable
            .merge(
                //주로 단 1개의 아이템만 내보내는 것을 보장하기 위해 take(1) 형태로 사용
                currentLocation.take(1),
                moveToCurrentLocation
            )
        
        setMapCenter = currentMapCenter
            .asSignal(onErrorSignalWith: .empty())
        
        errorMessage = mapViewError.asObservable()
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도해주세요")
    }
}
