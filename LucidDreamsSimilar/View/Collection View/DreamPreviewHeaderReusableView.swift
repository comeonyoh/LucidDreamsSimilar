//
//  DreamPreviewHeaderReusableView.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/13.
//

import UIKit
import SpriteKit

class DreamPreviewHeaderReusableView: UICollectionReusableView {
    
    static let reuseIdentifier = "\(DreamPreviewHeaderReusableView.self)"
    
    private let skView: SKView
    
    var dream: Dream! {
        didSet {
            guard dream != nil else { return }
            
            skView.allowsTransparency = true
            skView.backgroundColor = .clear
            
            if let scene = skView.scene as? DreamScene {
                scene.size = frame.size
                scene.dream = dream
            }
            else {
                skView.presentScene(DreamScene(dream: dream, size: frame.size))
            }
        }
    }
    
    override init(frame: CGRect) {
        
        skView = SKView(frame: .init(origin: .zero, size: frame.size))
        super.init(frame: frame)
        
        addSubview(skView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
