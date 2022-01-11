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
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
