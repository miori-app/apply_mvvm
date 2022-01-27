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
    
    let currentLocationBtnTapped = PublishRelay<Void>()
}
