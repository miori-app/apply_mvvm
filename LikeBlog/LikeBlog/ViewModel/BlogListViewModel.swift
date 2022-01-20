//
//  BlogListViewModel.swift
//  LikeBlog
//
//  Created by miori Lee on 2022/01/20.
//

import RxSwift
import RxCocoa

struct BlogListViewModel {
    // 블로그 리스트 뷰가 필터뷰를 헤더로 가지고 있으니까
    let filterViewModel = FilterViewModel()
    
    // 외부에서 알게 하기위함
    let blogCellData = PublishSubject<[BlogListCellData]>()
    // 자기 자신은 이게 뭔지 아니까 driver 로
    let cellData : Driver<[BlogListCellData]>
    
    
    init() {
        self.cellData = blogCellData.asDriver(onErrorJustReturn: [])
    }
}
