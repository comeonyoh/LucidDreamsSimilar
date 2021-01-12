//
//  InsetLayout.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/12.
//

import UIKit

struct InsetLayout<Child: Layout>: Layout {

    typealias Content = Child.Content
    
    var child: Child
    
    var insets: UIEdgeInsets
    
    init(child: Child, insets: UIEdgeInsets) {
        self.child = child
        self.insets = insets
    }
    
    mutating func layout(in rect: CGRect) {
        child.layout(in: rect.inset(by: insets))
    }
    
    var contents: [Content] {
        child.contents
    }
}

extension Layout {
    
    func withInsets(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> InsetLayout<Self> {
        let insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return withInsets(insets)
    }
    
    func withInsets(all insets: CGFloat) -> InsetLayout<Self> {
        return withInsets(top: insets, left: insets, bottom: insets, right: insets)
    }
    
    func withInsets(_ insets: UIEdgeInsets) -> InsetLayout<Self> {
        return InsetLayout(child: self, insets: insets)
    }
}
