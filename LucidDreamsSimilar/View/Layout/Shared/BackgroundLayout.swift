//
//  BackgroundLayout.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/12.
//

import CoreGraphics

struct BackgroundLayout<Background: Layout, Foreground: Layout>: Layout where Background.Content == Foreground.Content {
    
    typealias Content = Background.Content
    
    var background: Background
    var foreground: Foreground
    
    
    mutating func layout(in rect: CGRect) {
        background.layout(in: rect)
        foreground.layout(in: rect)
    }
    
    var contents: [Content] {
        background.contents + foreground.contents
    }
}

extension Layout {
    
    func withBackground<Background: Layout>(_ background: Background) -> BackgroundLayout<Background, Self> where Background.Content == Content {
        return BackgroundLayout(background: background, foreground: self)
    }
}
