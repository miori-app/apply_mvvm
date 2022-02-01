//
//  DetailCellData.swift
//  NearByApp
//
//  Created by miori Lee on 2022/01/26.
//

import Foundation

struct DetailCellData {
    let placeName : String
    let addressName : String
    let distance : String
    // 셀 탭했을때, 지도에 띄우기위해
    let point : MTMapPoint
}
