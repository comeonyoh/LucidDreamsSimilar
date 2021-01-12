//
//  Layout.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/12.
//

import CoreGraphics

protocol Layout {
    
    mutating func layout(in rect: CGRect)
    
    associatedtype Content
    
    var contents: [Content] { get }
}

