//
//  UIView+Extensions.swift
//  FLO
//
//  Created by 김성준 on 4/16/24.
//

import UIKit

public extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
