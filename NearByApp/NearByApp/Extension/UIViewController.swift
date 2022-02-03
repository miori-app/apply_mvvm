//
//  UIViewController.swift
//  NearByApp
//
//  Created by miori Lee on 2022/02/03.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension UIViewController {
    typealias Alert = (title: String?, message: String?, actions : [AlertAction], style : UIAlertController.Style)
    
    enum AlertAction : AlertActionConvertible {
        
        case a,b,cancel
        case confirm
        
        var title: String {
            switch self {
            case .a :
                return "500m"
            case .b :
                return "1000m"
            case .cancel :
                return "cancel"
            case .confirm :
                return "확인"
            }
        }
        
        var style: UIAlertAction.Style {
            switch self {
            case .a,.b :
                return .default
            case .cancel, .confirm :
                return .cancel
            }
        }
    }
    
    //MARK: alert의 action을 받았을때, alertcontroller 생성할 수 있는 함수
    func presentAlertController<Action: AlertActionConvertible>(_ alertController : UIAlertController, actions : [Action]) -> Signal<Action> {
        if actions.isEmpty {return .empty()}
        return Observable
            .create {[weak self] observer in
                guard let self = self else { return Disposables.create() }
                for action in actions {
                    alertController.addAction (
                        UIAlertAction(title: action.title, style: action.style, handler: {_ in
                            observer.onNext(action)
                            observer.onCompleted()
                    })
                )
            }
                self.present(alertController, animated: true, completion: nil)
                return Disposables.create {
                    alertController.dismiss(animated: true, completion: nil)
                }
            }
            .asSignal(onErrorSignalWith: .empty())
    }
}
