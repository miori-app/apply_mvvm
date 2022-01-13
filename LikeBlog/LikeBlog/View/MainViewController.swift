//
//  MainViewController.swift
//  LikeBlog
//
//  Created by miori Lee on 2022/01/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    let searchBar = SearchBar()
    let listView = BlogListView()
    
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
    typealias Alert = (title: String?, message: String?, actions : [AlertAction], style : UIAlertAction.Style)
    
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
