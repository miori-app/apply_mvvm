//
//  BlogListView.swift
//  LikeBlog
//
//  Created by miori Lee on 2022/01/12.
//

import RxCocoa
import RxSwift
import UIKit

class BlogListView : UITableView {
    let disposeBag = DisposeBag()
    let headerView = FilterView(frame: CGRect(origin: .zero, size: CGSize(width: Constant.deviceWidth, height: 50)))

    // MVVM 이동 (viewModel 로)
//    // MainViewController -> BlogListView
//    // 받아올 이벤트
//    let cellData = PublishSubject<[BlogListCellData]>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        // bind()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(_ viewModel : BlogListViewModel) {
        //셀 데이터를 받아서, Observable 어떻게 처리할지
        // mainViewController가 celldata 잘 전달해주면, 이걸 어떻게 표현할지
        // tableview delegate : cellForRowAt
        viewModel.cellData
            //.asDriver(onErrorJustReturn: [])
            .drive(self.rx.items) { tv, row, data in
                let index = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: "BlogListCell", for: index) as! BlogListCell
                cell.setData(data)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.backgroundColor = .white
        self.register(BlogListCell.self, forCellReuseIdentifier: BlogListCell.registerID)
        self.separatorStyle = .singleLine
        self.rowHeight = 96 
        self.tableHeaderView = headerView
    }
}
