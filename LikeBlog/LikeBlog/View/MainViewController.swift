//
//  MainViewController.swift
//  LikeBlog
//
//  Created by miori Lee on 2022/01/10.
//

import UIKit
import Foundation
import SnapKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    let searchBar = SearchBar()
    let listView = BlogListView()
    
    // alert action 탭 했을때 이벤트 확인하기위함
    let alertActionTapped = PublishRelay<AlertAction>()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // for Rx
    private func bind() {
        // searchBar 에서 shouldLoadResult Observable에서 이벤트 나오면 작동
        let blogResult = searchBar.shouldLoadResult
            .flatMapLatest { query in
                SearchBlogNetwork().searchNetwork(query: query)
            }
            // stream 새로 만드는게 아니라 공유할거라서
            .share()
        
        // 다음 블로그 값만 넣어주기
        let blogValue = blogResult
            .compactMap { data -> DaumBlog? in
                //enums can have associated values
                guard case .success(let value) = data else {
                    return nil
                }
                return value
            }
        // 에러값
        let blogError = blogResult
            .compactMap { data -> String? in
                guard case .failure(let error) = data else {
                    return nil
                }
                return error.localizedDescription
            }
        
        // 네트워크를 통해 가져온 값 -> 셀데이터로 변환
        let cellData = blogValue
            .map { blog -> [BlogListCellData] in
                return blog.documents
                    .map { doc in
                        let thumbnailURL = URL(string: doc.thumbnail ?? "")
                        return BlogListCellData(thumbnailURL: thumbnailURL,
                                                name:  doc.blogname,
                                                title: doc.title,
                                                datetime: doc.datetime)
                    }
            }
        
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
            .combineLatest(sortedType, cellData) { type, data -> [BlogListCellData] in
                switch type {
                case .title :
                    return data.sorted { $0.title ?? "" < $1.title ?? ""}
                case .datetime :
                    return data.sorted { $0.datetime ?? Date() > $1.datetime ?? Date() }
                default :
                    return data
                }
            }
            .bind(to: listView.cellData)
            .disposed(by: disposeBag)
        //listView.headerView.sortBtnTapped 이벤트를 -> alert으로
        let alertSheetForSorting = listView.headerView.sortBtnTapped
            .map { _ -> Alert in
                return (title: nil, message: nil, actions : [.title, .datetime, .cancel], style : .actionSheet)
            }
        let alertForMessage = blogError
            .map { msg -> Alert in
                return (
                    title : "⚠️",
                    message : msg,
                    actions : [.confirm],
                    style : .alert
                )
            }
        
        Observable
            .merge(alertForMessage, alertSheetForSorting)
            .asSignal(onErrorSignalWith: .empty())
        //. flatMapLatest는 새로운 스트림을 만들고 동작을 수행하는 도중, 새로운 아이템이 방출되게 된다면, 이전 스트림을 dispose 하고 새롭게 들어오게 되는 아이템에 대해 스트림을 생성하여 동작
            .flatMapLatest { alert -> Signal<AlertAction> in
                let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: alert.style)
                return self.presentAlertController(alertController, actions: alert.actions)
            }
            //구독
            .emit(to: alertActionTapped)
            .disposed(by: disposeBag)
    }
    
    // view 꾸미기
    private func attribute() {
        title = "다음 블로그 검색"
        view.backgroundColor = .white
    }
    
    // snapkit
    private func layout() {
        [searchBar,listView].forEach { view.addSubview($0)}
        searchBar.snp.makeConstraints {
            //navigation bar 아래
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        listView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

// Alert
extension MainViewController {
    typealias Alert = (title: String?, message: String?, actions : [AlertAction], style : UIAlertController.Style)
    
    enum AlertAction : AlertActionConvertible {
        //액션들을 선언
        case title,datetime,cancel
        case confirm
        
        var title: String {
            switch self {
            case .title :
                return "Title"
            case .datetime :
                return "Datetime"
            case .cancel :
                return "취소"
            case . confirm :
                return "확인"
            }
        }
        
        var style: UIAlertAction.Style {
            switch self {
            case .title, .datetime :
                return .default
            case .cancel, .confirm :
                return .cancel
            }
        }
    }
    // Observable : 값을 방출
    //MARK: alert의 action을 받았을때, alertcontroller 생성할 수 있는 함수
    func presentAlertController<Action : AlertActionConvertible>(_ alertController : UIAlertController, actions: [Action]) -> Signal<Action> {
        if actions.isEmpty {return .empty()}
        return Observable
            .create { [weak self] observer in
                //캡쳐: 자신의 블록 외부에 있는 값을 참조하는 것
                //클로저 내에서 외부 프로퍼티를 캡처할때, 현재 instance가 heap에 존재하면 객체를 Strong으로 참조하고, instance가 해제 되었으면 nil을 반환하여 탈출
                /*
                 - 이스케이핑 클로저 안에서 지연할당의 가능성이 있는 경우 (API 비동기 데이터 처리, 타이머 등)
                 - 이스케이핑 클로저가 아닌 일반 클로저에서는 Scope안에서 즉시 실행되므로 Strong Reference Cycle을 유발하지 않으므로, weak self를 사용할 필요가 없다.
                 */
                guard let self = self else {return Disposables.create() }
                for action in actions {
                    alertController.addAction(
                        UIAlertAction(title: action.title, style: action.style, handler: {_ in
                            observer.onNext(action)
                            observer.onCompleted()
                        })
                    )
                }
                self.present(alertController, animated: true, completion: nil)
                // observable 생성되면 alertController dismiss
                return Disposables.create {
                    alertController.dismiss(animated: true, completion: nil)
                }
            }
            .asSignal(onErrorSignalWith: .empty())
    }
}
