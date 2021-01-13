//
//  EffectCollectionViewCell.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/13.
//

import UIKit
import SpriteKit

class EffectCollectionViewCell: UICollectionViewCell {

    private enum NodeName: String {
        case effect = "effect"
        case border = "border"
    }
    
    static let reuseIdentifier = "\(EffectCollectionViewCell.self)"
    
    private var scene: SKScene?
    
    var effect: Dream.Effect! {
        
        didSet {
            
            guard let scene = scene else {
                return
            }
            
            let emitterNode = scene.childNode(withName: NodeName.effect.rawValue) as! SKEmitterNode
            emitterNode.removeFromParent()
            
            addNode(for: effect, in: scene)
        }
    }
    
    func addNode(for effect: Dream.Effect, in scene: SKScene) {
        let effectNode = effect.makeNode()
        effectNode.position = effect.position(in: bounds)
        effectNode.name = NodeName.effect.rawValue
        scene.addChild(effectNode)
    }
    
    override var isSelected: Bool {
        set {
            super.isSelected = isSelected
            
            guard let scene = scene else { return }
            
            if newValue {
                addBorderNode(in: scene)
            }
            else if let borderNode = scene.childNode(withName: NodeName.border.rawValue) {
                scene.removeChildren(in: [borderNode])
            }
        }
        get {
            super.isSelected
        }
    }
    
    func addBorderNode(in scene: SKScene) {
        
        guard scene.childNode(withName: NodeName.border.rawValue) == nil else {
            return
        }
        
        let borderNode = SKCropNode()
        let maskNode = SKShapeNode(rectOf: bounds.size)
        
        maskNode.position = CGPoint(x: bounds.midX, y: bounds.midY)
        maskNode.lineWidth = 3
        maskNode.strokeColor = .blue
        maskNode.fillColor = .clear
        
        borderNode.maskNode = maskNode
        borderNode.addChild(maskNode)
        borderNode.name = NodeName.border.rawValue
        scene.addChild(borderNode)
    }
    
    override func layoutSubviews() {
        
        guard self.scene == nil else {
            return
        }
        
        let skView = SKView(frame: bounds)
        contentView.addSubview(skView)
        skView.allowsTransparency = true
        skView.backgroundColor = .clear
        
        let scene = SKScene(size: bounds.size)
        scene.backgroundColor = .clear
        self.scene = scene
        
        addNode(for: effect, in: scene)
        
        if isHighlighted {
            addBorderNode(in: scene)
        }
        
        skView.presentScene(scene)
    }
}

extension Dream.Effect {
    
    func position(in bounds: CGRect) -> CGPoint {
        
        var position = CGPoint(x: bounds.midX, y: bounds.midY)
        
        switch self {
            case .fireBreathing:
                position.x -= 30
                position.y += 30
                
            case .laserFocus:
                position.x -= 30
                
            default:
                break
        }
        
        return position
    }
}
