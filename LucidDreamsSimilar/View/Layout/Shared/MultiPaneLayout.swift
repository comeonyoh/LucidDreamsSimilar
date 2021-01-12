//
//  MultiPaneLayout.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/12.
//

import CoreGraphics


struct MultiPaneLayout<ChildContent: Layout, Accessory: Layout>: Layout where ChildContent.Content == Accessory.Content {
    
    typealias Content = ChildContent.Content
    
    private var composedLayout: DecoratingLayout<ChildContent, CascadingLayout<Accessory>>
    
    init(content: ChildContent, accessories: [Accessory]) {
        composedLayout = DecoratingLayout(content: content, decoration: CascadingLayout(children: accessories))
    }
    
    mutating func layout(in rect: CGRect) {
        composedLayout.layout(in: rect)
    }
    
    var contents: [Content] {
        composedLayout.contents
    }
}
