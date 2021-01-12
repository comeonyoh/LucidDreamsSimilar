//
//  ZStackLayout.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/12.
//

import CoreGraphics

struct ZStackLayout<Child: Layout>: Layout {
    
    typealias Content = Child.Content
    
    var children: [Child]
    
    mutating func layout(in rect: CGRect) {
        
        for index in children.indices {
            children[index].layout(in: rect)
        }
    }
    
    var contents: [Content] {
        children.flatMap {
            $0.contents
        }
    }
}
