//
//  DreamScene.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/13.
//

import SpriteKit

class DreamScene: SKScene {
    
    var dream: Dream {
        didSet {
            dataDidChange()
        }
    }
    
    private var decoration: SKSpriteNode?
    private var content: SKLabelNode?
    private var effectNodes: [(Dream.Effect, SKNode)] = []
    
    init(dream: Dream, size: CGSize) {
        
        self.dream = dream
        
        super.init(size: size)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dataDidChange() {
        
        decoration = decoration ?? {
           let decoration = SKSpriteNode()
            addChild(decoration)
            return decoration
        }()
        
        decoration!.texture = SKTexture(image: dream.creature.image)
        
        content = content ?? {
            let content = SKLabelNode()
            content.fontColor = .black
            addChild(content)
            return content
        }()
        
        content!.text = dream.description
        
        removeChildren(in: effectNodes.map {$1})
        
        effectNodes = dream.effects.map {
            ($0, $0.makeNode())
        }
        
        for (idx, (_, effectNode)) in effectNodes.enumerated() {
            effectNode.zPosition = CGFloat(idx)
            addChild(effectNode)
        }
        
        layout()
    }
    
    override func didMove(to view: SKView) {
        layout()
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        layout()
    }
    
    func layout() {
        
        guard let decoration = decoration, let content = content else { return }
        
        let insettedEffectNodes = effectNodes.map {
            $1.withInsets($0.insetsForDisplaying)
        }
        
        var dreamEffectLayout = DreamEffectLayout(content: content, decoration: decoration, effects: insettedEffectNodes)
        dreamEffectLayout.layout(in: frame)
        
        for (idx, leaf) in dreamEffectLayout.contents.enumerated() {
            leaf.zPosition = CGFloat(idx)
        }
    }
}

extension Dream.Effect {
    
    var insetsForDisplaying: UIEdgeInsets {
        
        switch self {
            case .fireBreathing:
                return .init(top: 0, left: 100, bottom: -80, right: 0)
                
            case .laserFocus:
                return .init(top: 0, left: 30, bottom: 20, right: 0)
                
            default:
                return .zero
        }
    }
}
