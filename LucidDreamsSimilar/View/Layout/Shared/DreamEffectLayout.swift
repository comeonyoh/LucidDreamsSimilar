//
//  DreamEffectLayout.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/12.
//

import CoreGraphics

struct DreamEffectLayout<ChildContent: Layout, Decoration: Layout, Effect: Layout>: Layout where ChildContent.Content == Decoration.Content, ChildContent.Content == Effect.Content {
    
    typealias Content = ChildContent.Content
    
    private var content: ChildContent
    private var decoration: Decoration
    private var effects: [Effect]
    
    init(content: ChildContent, decoration: Decoration, effects: [Effect]) {
        self.content = content
        self.decoration = decoration
        self.effects = effects
    }
    
    mutating func layout(in rect: CGRect) {
        
        let stack = ZStackLayout(children: effects)
        let combinedDecoration = stack.withBackground(decoration)
        
        var decoratingLayout = DecoratingLayout(content: content, decoration: combinedDecoration)
        decoratingLayout.layout(in: rect)
    }
    
    var contents: [Content] {
        content.contents + decoration.contents + effects.flatMap({
            $0.contents
        })
    }
}
