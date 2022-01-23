//
//  MainViewModel.swift
//  LikeBlog
//
//  Created by miori Lee on 2022/01/20.
//

import RxSwift
import RxCocoa
import Foundation

struct MainViewModel {
    let disposeBag = DisposeBag()
    
    let blogListViewModel = BlogListViewModel()
    let searchBarViewModel = SearchBarViewModel()
    
    // alert action 탭 했을때 이벤트 확인하기위함
    let alertActionTapped = PublishRelay<MainViewController.AlertAction>()
    
    let shouldPresentAlert : Signal<MainViewController.Alert>
    
    
    init(model : MainModel = MainModel()) {
        
        // MARK: 빈 검색어 일때, Alert
        let emptyAlertMsg = searchBarViewModel.searchBtnTapped
        //버튼 이벤트와 쿼리텍스트($1) 스트림
            .withLatestFrom(searchBarViewModel.queryText) { $1 ?? "" }
        // empty 일때만
            .filter { $0.isEmpty }
            .map { _ -> MainViewController.Alert in
                return (
                    title : "⚠️",
                    message : "검색어를 입력해주세요",
                    actions : [.confirm],
                    style : .alert
                )
            }
        
        // searchBar 에서 shouldLoadResult Observable에서 이벤트 나오면 작동
        let blogResult = searchBarViewModel.shouldLoadResult
            .flatMapLatest (model.searchBlog)
        // stream 새로 만드는게 아니라 공유할거라서
            .share()
        
        // 다음 블로그 값만 넣어주기
        let blogValue = blogResult
            .compactMap(model.getBlogValue)
        // 에러값
        let blogError = blogResult
            .compactMap(model.getBlogError)
        
        //MARK: 네트워크를 통해 가져온 값 -> 셀데이터로 변환
        let cellData = blogValue
            .map(model.getBlogListCellData)
        
        // filter btn 누르면 나오는 alert sheet 선택했을때 type
        let sortedType = alertActionTapped
            .filter {
                switch $0 {
                case .title, .datetime :
                    return true
                default :
                    return false
                }
            }
            .startWith(.title)
        
        
        // MainVC -> ListView
        // cellData _ sortedType
        Observable
        //두개의 소스를 받아서 resultSelector처럼 결과를 구현해라
            .combineLatest(sortedType, cellData, resultSelector: model.sort)
            .bind(to: blogListViewModel.blogCellData)
            .disposed(by: disposeBag)
        
        //MARK: 에러처리, alert 띄우기
        //listView.headerView.sortBtnTapped 이벤트를 -> alert으로
        let alertSheetForSorting = blogListViewModel.filterViewModel.sortBtnTapped
            .map { _ -> MainViewController.Alert in
                return (title: nil, message: nil, actions : [.title, .datetime, .cancel], style : .actionSheet)
            }
        let alertForMessage = blogError
            .map { msg -> MainViewController.Alert in
                return (
                    title : "⚠️",
                    message : msg,
                    actions : [.confirm],
                    style : .alert
                )
            }
        
        self.shouldPresentAlert = Observable
            .merge(alertForMessage, alertSheetForSorting
                   , emptyAlertMsg)
            .asSignal(onErrorSignalWith: .empty())
    }
}
