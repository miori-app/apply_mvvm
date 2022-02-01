//
//  LocalNetwork.swift
//  NearByApp
//
//  Created by miori Lee on 2022/02/01.
//

import Foundation
import RxSwift

class LocalNetwork {
    private let session : URLSession
    let api = LocalAPI()
    
    init(session : URLSession = .shared) {
        self.session = session
    }
     
    //MARK: 네트워크 (성공/실패) 따라서 single 사용
    func getLocation(by mapPoint : MTMapPoint) -> Single<Result<LocationResponse, URLError>> {
        guard let url = api.getLocation(by: mapPoint).url else {
            return .just(.failure(URLError(.badURL)))
        }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        //헤더
        request.setValue("\(Secret.kakaoKey)", forHTTPHeaderField: "Authorization")
        return session.rx.data(request: request as URLRequest)
            .map { data in
                //json decoding
                do {
                    let locationData = try JSONDecoder().decode(LocationResponse.self, from: data)
                    return .success(locationData)
                } catch {
                    return .failure(URLError(.cannotParseResponse))
                }
            }
            .catch {
                _ in .just(Result.failure(URLError(.cannotLoadFromNetwork)))
            }
            .asSingle()
    }
}
