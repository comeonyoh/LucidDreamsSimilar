//
//  UIView+Layout.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/12.
//

import UIKit

extension UIView: Layout {
    
    typealias Content = UIView
    
    func layout(in rect: CGRect) {
        self.frame = rect
    }
    
    var contents: [Content] {
        [self]
    }
}
