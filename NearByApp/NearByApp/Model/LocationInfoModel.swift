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
    
    func getLocation(by mapPoint: MTMapPoint) -> Single<Result<LocationResponse,URLError>> {
        return localNetwork.getLocation(by: mapPoint)
    }
    
    func documentsToCellData(_ data: [DetailLocData]) -> [DetailCellData] {
        return data.map {
            let addressName = $0.roadAddressName.isEmpty ? $0.addressName : $0.roadAddressName
            let point = docToMapPoint($0)
            return DetailCellData(placeName: $0.placeName, addressName: addressName, distance: $0.distance, point: point)
        }
    }
    
    func docToMapPoint(_ doc : DetailLocData) -> MTMapPoint {
        let longitude = Double(doc.x) ?? .zero
        let latitude = Double(doc.y) ?? .zero
        return MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude))
    }
    
    
}
