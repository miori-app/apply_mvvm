//
//  AlertActionConvertible.swift
//  NearByApp
//
//  Created by miori Lee on 2022/02/03.
//

import UIKit

protocol AlertActionConvertible{
    var title : String { get }
    var style : UIAlertAction.Style { get }
}
