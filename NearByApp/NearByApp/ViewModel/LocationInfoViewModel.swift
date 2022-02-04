//
//  LocationInfoViewModel.swift
//  NearByApp
//
//  Created by miori Lee on 2022/01/26.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

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
    
    let shouldPresentAlert : Signal<UIViewController.Alert>
    
    // view -> viewModel
    let currentLocation = PublishRelay<MTMapPoint>()
    let mapCenterPoint = PublishRelay<MTMapPoint>()
    let selectPOIItem = PublishRelay<MTMapPOIItem>()
    let mapViewError =  PublishRelay<String>()
    let currentLocationBtnTapped = PublishRelay<Void>()
    // 리스트 선택시 row값
    let detailListItemSelected = PublishRelay<Int>()
    //api데이터용
    let documetData = PublishSubject<[DetailLocData]>()
    // navi rightbtn sort 눌렸을때
    let sortBtnTapped = PublishRelay<Void>()
    
    // alert action 탭 했을때 이벤트 확인하기위함
    let alertActionTapped = PublishRelay<UIViewController.AlertAction>()
    
    init(_ networkMoel : LocationInfoModel = LocationInfoModel()) {
        //MARK: 네트워크 통신으로 데이터 불러오기
        let locationResult = mapCenterPoint
        //mapCenterPoint를 가지고 왔을때
            .flatMapLatest(networkMoel.getLocation)
            .share()
        
        let locationResultValue = locationResult
        //nil사라짐
            .compactMap { data -> LocationResponse? in
                guard case let .success(value) = data else {
                    return nil
                }
                return value
            }
        
        let locationResultError = locationResult
            .compactMap { data -> String? in
                switch data {
                case let .failure(error) :
                    return error.localizedDescription
                case let .success(data) where data.documents.isEmpty :
                    return "근방에 존재하지 않아요"
                default :
                    return nil
                }
            }
        
        locationResultValue
            .map {
                $0.documents
            }
            .bind(to: documetData)
            .disposed(by: disposeBag)
        
        
        //MARK: 지도의 중심점 선택
        /*
         api통신을 통해 json데이터를 받게되면,그중 선택된 리스트 값의 entity 중 x,y 값 string  -> 위도 경도 더블로 변경
         */
        let selectDetailListItem = detailListItemSelected
            .withLatestFrom(documetData) { $1[$0] }
            .map { data -> MTMapPoint in
                guard let lon = Double(data.x),
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
        
        //        errorMessage = mapViewError.asObservable()
        //            .asSignal(onErrorJustReturn: "잠시 후 다시 시도해주세요")
        errorMessage = Observable
            .merge(
                locationResultError,
                mapViewError.asObservable()
            )
            .asSignal(onErrorJustReturn: "잠시후 다시 시도해주세요")
        
        detailListCellData = documetData
            .map(networkMoel.documentsToCellData)
            .asDriver(onErrorDriveWith: .empty())
        
        documetData
            .map {!$0.isEmpty}
            .bind(to: detailListBackgroundViewModel.shouldHideStatusLabel)
            .disposed(by: disposeBag)
        
        //selectPOIItem : 핑을 선택했을때 발생하는 이벤트
        scrollToSelectedLocation = selectPOIItem
            .map { $0.tag }
            .asSignal(onErrorJustReturn: 0)
        
        //fileterBtn눌렀을때 sheet띄우게 하기위해서
        let alertSheetForDistance = sortBtnTapped
            .map { _ -> UIViewController.Alert in
                return (title: nil, message: nil, actions: [.a,.b,.cancel], style: .actionSheet)
            }
        
        self.shouldPresentAlert = alertSheetForDistance
            .asSignal(onErrorSignalWith: .empty())
    }
}
