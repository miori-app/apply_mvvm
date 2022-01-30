//
//  DetailListBackgroundView.swift
//  NearByApp
//
//  Created by miori Lee on 2022/01/30.
//

import Foundation
import RxSwift
import RxCocoa

class DetailListBackgroundView : UIView {
    let disposeBag = DisposeBag()
    let statusLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel : DetailListBackgroundViewModel) {
        //뷰모델에서 가져온 isStatusLabelHidden값을 rx.isHidden과 연결
        viewModel.isStatusLabelHidden
            .emit(to: statusLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func attribute(){
        backgroundColor = .white
        statusLabel.text = "⚠️"
        statusLabel.textAlignment = .center
    }
    
    private func layout(){
        addSubview(statusLabel)
        statusLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
