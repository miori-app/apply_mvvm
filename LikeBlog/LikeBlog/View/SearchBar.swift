//
//  SearchBar.swift
//  LikeBlog
//
//  Created by miori Lee on 2022/01/10.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class SearchBar : UISearchBar {
    let disposeBag = DisposeBag()
    
    let searchBtn = UIButton()
    
// MARK: - mvvm 적용
//    // search bar btn tap event
//    // onNext 만 받고 eroor를 받지 않아
//    let searchBtnTapped = PublishRelay<Void>()
//
//    // search bar 외부로 이벤트 내보내기 (text)
//    var shouldLoadResult = Observable<String>.of("")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel : SearchBarViewModel) {
        print("실행됨??")
        // text 를 viewModel 에 전달
        self.rx.text
            .bind(to: viewModel.queryText)
            .disposed(by: disposeBag)
        // searchbar 의 search btn tapped (keyboard)
        // custom btn
        Observable
            .merge (
                //타입이 controlEvent이므로 observable로 타입 변경
                self.rx.searchButtonClicked.asObservable(),
                searchBtn.rx.tap.asObservable()
            )
            .bind(to: viewModel.searchBtnTapped)
            .disposed(by: disposeBag)
        
        viewModel.searchBtnTapped
            .asSignal()
            .emit(to: self.rx.endEditing)
            .disposed(by: disposeBag)
        
        // MVVM 적요으로 이동
        // view가 직접적으로 관여x
        // searchBtnTapped 가 트리거 역할
//        self.shouldLoadResult = searchBtnTapped
//            .withLatestFrom(self.rx.text) { $1 ?? "" }
//            .filter { !$0.isEmpty }
//            .distinctUntilChanged()
    }
    
    private func attribute() {
        searchBtn.setTitle("검색 ", for: .normal)
        searchBtn.setTitleColor(.systemBlue, for: .normal)
    }
    
    private func layout() {
        addSubview(searchBtn)
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalTo(searchBtn.snp.leading).offset(-12)
            $0.centerY.equalToSuperview()
        }
        
        searchBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
    }
}

extension Reactive where Base : SearchBar {
    var endEditing : Binder<Void> {
        return Binder(base) { base, _ in
            base.endEditing(true) //키보드 내려갈 수 있게
        }
    }
}
