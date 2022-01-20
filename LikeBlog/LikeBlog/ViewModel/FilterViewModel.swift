//
//  FilterViewModel.swift
//  LikeBlog
//
//  Created by miori Lee on 2022/01/20.
//

import RxSwift
import RxCocoa

struct FilterViewModel {
    //탭 버튼이 눌릴때 마다 이벤트가 전달되므로, viewModel만 보면 됨
    let sortBtnTapped = PublishRelay<Void>()
}
