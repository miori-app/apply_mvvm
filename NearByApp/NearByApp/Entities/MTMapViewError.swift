//
//  MTMapViewError.swift
//  NearByApp
//
//  Created by miori Lee on 2022/01/27.
//

import Foundation

enum MTMapViewError {
    case failedUpdatingCurrentLocation
    case locationAuthorizationDenied
    
    var errorDescription : String {
        switch self {
        case .failedUpdatingCurrentLocation :
            return "현재위치를 불러오지 못했습니다. 잠시후 다시 시도해주세요"
        case .locationAuthorizationDenied :
            return "위치정보 제공을 거부하시면, 현재 위치를 알 수 없어요"
        }
    }
}
