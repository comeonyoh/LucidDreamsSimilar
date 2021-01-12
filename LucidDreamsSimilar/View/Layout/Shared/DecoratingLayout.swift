//
//  DecoratingLayout.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/12.
//

import CoreGraphics

struct DecoratingLayout<ChildContent: Layout, Decoration: Layout>: Layout where ChildContent.Content == Decoration.Content {
    
    typealias Content = ChildContent.Content
    
    var content: InsetLayout<ChildContent>
    var decoration: InsetLayout<Decoration>
    
    init(content: ChildContent, decoration: Decoration) {
        self.content = content.withInsets(all: 5)
        self.decoration = decoration.withInsets(top: 5, bottom: 5, right: 5)
    }
    
    mutating func layout(in rect: CGRect) {
        content.layout(in: contentRect(in: rect))
        decoration.layout(in: decorationRect(in: rect))
    }
    
    func contentRect(in rect: CGRect) -> CGRect {
        var dstRect = rect
        dstRect.origin.x = rect.size.width / 3
        dstRect.size.width *= 2/3
        return dstRect
    }
    
    func decorationRect(in rect: CGRect) -> CGRect {
        var dstRect = rect
        dstRect.size.width /= 3
        return dstRect
    }
    
    var contents: [Content] {
        decoration.contents + content.contents
    }
}
