//
//  SearchBarViewModel.swift
//  LikeBlog
//
//  Created by miori Lee on 2022/01/19.
//

import RxSwift
import RxCocoa

struct SearchBarViewModel {
    // text  받기위해 (UI event)
    let queryText = PublishRelay<String?>()
    // search bar btn tap event
    // onNext 만 받고 eroor를 받지 않아
    let searchBtnTapped = PublishRelay<Void>()
    
    // search bar 외부로 이벤트 내보내기 (text)
    let shouldLoadResult : Observable<String>
    
    init() {
        self.shouldLoadResult = searchBtnTapped
            .withLatestFrom(queryText) { $1 ?? "" }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
    }
}
