//
//  LocationInfoViewController.swift
//  NearByApp
//
//  Created by miori Lee on 2022/01/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import CoreLocation

class LocationInfoViewController : UIViewController {
    
    let disposeBag = DisposeBag()
    let locationManger = CLLocationManager()
    let mapView = MTMapView()
    let currentLocBtn = UIButton()
    let detailList = UITableView()
    let detailListBackgroundView = DetailListBackgroundView()
    let viewModel = LocationInfoViewModel()
    let filterBtn = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManger.delegate = self
        
        bind(viewModel)
        attribute()
        layout()
    }
}

extension LocationInfoViewController {
    private func bind(_ viewModel : LocationInfoViewModel) {
        currentLocBtn.rx.tap
            .bind(to: viewModel.currentLocationBtnTapped)
            .disposed(by: disposeBag)
        
        //signal binding
        
        //mapview 에다가 center 값 받았으니,
        //해당값은 center로 해서 맵 이동시켜
        viewModel.setMapCenter
            .emit(to: mapView.rx.setMapCenterPoint)
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            //에러 메세지를 받을때마다 실행됨
            .emit(to: self.rx.presentAlert)
            .disposed(by: disposeBag)
        
        //detailListBackgroundView viewModel추가
        detailListBackgroundView.bind(viewModel.detailListBackgroundViewModel)
        
        viewModel.detailListCellData
            .drive(detailList.rx.items) {
                tv, row, data in
                let cell = tv.dequeueReusableCell(withIdentifier: DetailListTableViewCell.registerID, for: IndexPath(row: row, section: 0)) as! DetailListTableViewCell
                cell.setData(data)
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.detailListCellData
            .map { $0.compactMap { $0.point }}
        //mapView형식에서 핑뿌려주기
            .drive(self.rx.addPOIItemRx)
            .disposed(by: disposeBag)
        
        viewModel.scrollToSelectedLocation
        //scrollToSelectedLocation를 받았을때
        //emit 뭘할지
            .emit(to: self.rx.showSelectedLocation)
            .disposed(by: disposeBag)
        
        detailList.rx.itemSelected
            .map {$0.row}
            .bind(to: viewModel.detailListItemSelected)
            .disposed(by: disposeBag)
        
        filterBtn.rx.tap
            .bind(to: viewModel.sortBtnTapped)
            .disposed(by: disposeBag)
    }

    private func attribute() {
        self.title = "내 근처 편의점 찾기"
        self.navigationItem.rightBarButtonItem = filterBtn
        view.backgroundColor = .white
        
        mapView.currentLocationTrackingMode = .onWithoutHeadingWithoutMapMoving
        currentLocBtn.setImage(UIImage(systemName: "location.fill"), for: .normal)
        currentLocBtn.backgroundColor = .white
        currentLocBtn.layer.cornerRadius = 20
        
        //cell register
        detailList.register(DetailListTableViewCell.self, forCellReuseIdentifier: DetailListTableViewCell.registerID)
        detailList.separatorStyle = .none
        detailList.backgroundView = detailListBackgroundView
    }
    
    private func layout() {
        [mapView, currentLocBtn, detailList].forEach {
            view.addSubview($0)
        }
        mapView.snp.makeConstraints {
            //navi 상단 밑에 위치
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.snp.centerY).offset(100)
        }
        currentLocBtn.snp.makeConstraints {
            $0.bottom.equalTo(detailList.snp.top).offset(-12)
            $0.leading.equalToSuperview().offset(12)
            $0.width.height.equalTo(40)
        }
        detailList.snp.makeConstraints {
            $0.centerX.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.top.equalTo(mapView.snp.bottom)
        }
    }
}


extension LocationInfoViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways,
                .authorizedWhenInUse,
                .notDetermined:
            return
        default :
            //에러모델 작성후, 에러반환
            viewModel.mapViewError.accept(MTMapViewError.locationAuthorizationDenied.errorDescription)
            return 
        }
    }
}

extension LocationInfoViewController : MTMapViewDelegate {
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        //#if DEBUG
        //디버그 모드일때, 시뮬레이터는 위치 모르니까
        //viewModel.currentLocation.accept(MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.394225, longitude: 127.110341)))
        //#else
        //실제 위치 알때
        viewModel.currentLocation.accept(location)
        //#endif
    }
    
    //MARK: Map 움직이고 난뒤
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        //센터 포인터 다시 필요
        viewModel.mapCenterPoint.accept(mapCenterPoint)
    }
    
    //MARK: Pin을 선택할때 마다 MTMapPOIItem 정보제공
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        // 위치 넘겨주기
        viewModel.selectPOIItem.accept(poiItem)
        return false
    }
    
    func mapView(_ mapView: MTMapView!, failedUpdatingCurrentLocationWithError error: Error!) {
        //제대로된 위치 못 불러올때 에러 해결
        viewModel.mapViewError.accept(error.localizedDescription)
    }
}
