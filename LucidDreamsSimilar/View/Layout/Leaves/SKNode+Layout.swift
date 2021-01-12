//
//  SKNode+Layout.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/12.
//

import UIKit
import SpriteKit

extension SKNode: Layout {

    typealias Content = SKNode

    @objc func layout(in rect: CGRect) {
        let height = parent?.frame.size.height ?? 0
        position = CGPoint(x: rect.midY, y: height - rect.midY)
    }

    var contents: [SKNode] {
        [self]
    }
}

extension SKSpriteNode {
    
    @objc override func layout(in rect: CGRect) {
        super.layout(in: rect)
        size = rect.size
    }
}
