//
//  LocationResponse.swift
//  NearByApp
//
//  Created by miori Lee on 2022/01/26.
//

import Foundation

struct LocationResponse : Decodable {
    let documents : [DetailLocData]
}

struct DetailLocData : Decodable {
    let placeName : String
    let addressName : String
    let roadAddressName : String
    let x : String
    let y : String
    let distance : String
    let phone : String
    
    enum CodingKeys : String, CodingKey {
        case x, y, distance, phone
        case placeName = "place_name"
        case addressName = "address_name"
        case roadAddressName = "road_address_name"
    }
}
