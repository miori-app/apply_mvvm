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
