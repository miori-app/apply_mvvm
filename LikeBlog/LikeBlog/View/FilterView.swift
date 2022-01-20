//
//  FilterView.swift
//  LikeBlog
//
//  Created by miori Lee on 2022/01/10.
//

// alert sheet 를  올릴수 있도록 , 내가 눌렸다는 이벤트 방출
import RxSwift
import RxCocoa
import UIKit

class FilterView : UITableViewHeaderFooterView {
    let disposeBag = DisposeBag()
    
    let sortBtn = UIButton()
    let bottomBorder = UIView()
    
    // MVVM  적용
//    // filter view 외부에서 관찰
//    // 나 눌렸어 ~
//    // Relay 객체는 .completed, .error를 발생하지 않고 Dispose되기 전까지 계속 작동하기 때문에 UI 등에서 사용하기 적절
//    let sortBtnTapped = PublishRelay<Void>()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        //bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel : FilterViewModel) {
        sortBtn.rx.tap
            .bind(to: viewModel.sortBtnTapped)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        sortBtn.setImage(UIImage(systemName: "list.bullet"), for: .normal )
        bottomBorder.backgroundColor = .lightGray
    }
    
    private func layout(){
        [sortBtn, bottomBorder].forEach {
            addSubview($0)
        }
        sortBtn.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
            //$0.width.height.equalTo(28)
        }
        
        bottomBorder.snp.makeConstraints {
            $0.top.equalTo(sortBtn.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}
