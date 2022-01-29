//
//  UIViewController+Rx.swift
//  NearByApp
//
//  Created by miori Lee on 2022/01/29.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base : UIViewController {
    var presentAlert : Binder<String> {
        return Binder(base) { base, msg in
            let alertController = UIAlertController(title: "오류가 발생했어요", message: msg, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            
            alertController.addAction(action)
            
            base.present(alertController, animated: true, completion: nil)
        }
    }
}
