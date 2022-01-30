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
    
    //subView viewModel
    let detailListBackgroundViewModel = DetailListBackgroundViewModel()
    
    // viewModel -> view
    
    //Driver는 BehaviorRelay, Signal은 PublishRelay와 많은 공통점
    
    // 센터로
    let setMapCenter : Signal<MTMapPoint>
    let errorMessage : Signal<String>
    
    //tableView에 뿌리기 위해
    let detailListCellData : Driver<[DetailCellData]>
    //핑 선택시 테이블뷰 셀 인덱스로 이동위해
    let scrollToSelectedLocation : Signal<Int>
    
    // view -> viewModel
    let currentLocation = PublishRelay<MTMapPoint>()
    let mapCenterPoint = PublishRelay<MTMapPoint>()
    let selectPOIItem = PublishRelay<MTMapPOIItem>()
    let mapViewError =  PublishRelay<String>()
    let currentLocationBtnTapped = PublishRelay<Void>()
    // 리스트 선택시 row값
    let detailListItemSelected = PublishRelay<Int>()
    //api데이터용
    let documetData = PublishSubject<[DetailLocData?]>()
    
    init() {
        //MARK: 지도의 중심점 선택
        /*
         api통신을 통해 json데이터를 받게되면,그중 선택된 리스트 값의 entity 중 x,y 값 string  -> 위도 경도 더블로 변경
         */
        let selectDetailListItem = detailListItemSelected
            .withLatestFrom(documetData) { $1[$0] }
            .map { datas -> MTMapPoint in
                guard let data = datas,
                      let lon = Double(data.x),
                      let lat = Double(data.y) else {
                          return MTMapPoint()
                      }
                let geoCoord = MTMapPointGeo(latitude: lat, longitude: lon)
                return MTMapPoint(geoCoord: geoCoord)
            }
        let moveToCurrentLocation = currentLocationBtnTapped
            // 현재위치 한번이라도 받은 이후에
            .withLatestFrom(currentLocation)
        
        let currentMapCenter  = Observable
            .merge(
                //주로 단 1개의 아이템만 내보내는 것을 보장하기 위해 take(1) 형태로 사용
                currentLocation.take(1),
                //새로운 위치 버튼을 누르거나
                moveToCurrentLocation,
                //리스트에서 선택한 경우
                selectDetailListItem
            )
        
        setMapCenter = currentMapCenter
            .asSignal(onErrorSignalWith: .empty())
        
        errorMessage = mapViewError.asObservable()
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도해주세요")
        
        detailListCellData = Driver.just([])
        
        //selectPOIItem : 핑을 선택했을때 발생하는 이벤트
        scrollToSelectedLocation = selectPOIItem
            .map { $0.tag }
            .asSignal(onErrorJustReturn: 0)
    }
}
