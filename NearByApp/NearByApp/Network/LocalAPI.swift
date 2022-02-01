//
//  LocalAPI.swift
//  NearByApp
//
//  Created by miori Lee on 2022/02/01.
//

import Foundation

//https://dapi.kakao.com/v2/local/search/category?category_group_code=PK6&x=127.110341&y=37.394225&radius=500&sort=distance
// api를 어떤 방식으로 전달할지
struct LocalAPI {
    static let scheme = "https"
    static let host = "dapi.kakao.com"
    static let path = "/v2/local/search/category.json"
    
    func getLocation(by mapPoint: MTMapPoint) -> URLComponents {
        var componets = URLComponents()
        componets.scheme = LocalAPI.scheme
        componets.host = LocalAPI.host
        componets.path = LocalAPI.path
        
        componets.queryItems = [
        URLQueryItem(name: "category_group_code", value: "PK6"),
        URLQueryItem(name: "x", value: "\(mapPoint.mapPointGeo().longitude)"),
        URLQueryItem(name: "y", value: "\(mapPoint.mapPointGeo().latitude)"),
        URLQueryItem(name: "radius", value: "500"),
        URLQueryItem(name: "sort", value: "distance")
        ]
        
        return componets
    }
}
