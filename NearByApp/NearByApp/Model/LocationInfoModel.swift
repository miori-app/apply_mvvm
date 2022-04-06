//
//  LocationInfoModel.swift
//  NearByApp
//
//  Created by miori Lee on 2022/02/01.
//

import Foundation
import RxSwift

struct LocationInfoModel {
    let localNetwork : LocalNetwork
    
    init(localNetwork : LocalNetwork = LocalNetwork()) {
        self.localNetwork = localNetwork
    }
    
    func getLocation(mapPoint: MTMapPoint) -> Single<Result<LocationResponse,URLError>> {
        return localNetwork.getLocation(mapPoint: mapPoint)
    }
    
    func documentsToCellData(_ data: [DetailLocData]) -> [DetailCellData] {
        return data.map {
            //let addressName = $0.roadAddressName.isEmpty ? $0.addressName : $0.roadAddressName
            let phoneNum = $0.phone.isEmpty ? "🥹 번호가 등록되지 않았어요" : "📞 \($0.phone)"
            let point = docToMapPoint($0)
            return DetailCellData(placeName: $0.placeName, phone: phoneNum, distance: $0.distance, point: point)
        }
    }
    
    func docToMapPoint(_ doc : DetailLocData) -> MTMapPoint {
        let longitude = Double(doc.x) ?? .zero
        let latitude = Double(doc.y) ?? .zero
        return MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude))
    }
    
    func applyNewDistance(type : UIViewController.AlertAction, mapPoint : MTMapPoint) {
        switch type{
        case .a:
            print("500m")
        case .b:
            print("1000m")
        default:
            print("zz")
        }
    }
    
}
