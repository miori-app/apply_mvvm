//
//  AlertActionConvertible.swift
//  LikeBlog
//
//  Created by miori Lee on 2022/01/13.
//

import UIKit

protocol AlertActionConvertible{
    var title : String { get }
    var style : UIAlertAction.Style { get }
}
