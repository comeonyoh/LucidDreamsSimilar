//
//  CreatureCollectionViewCell.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/13.
//

import UIKit

class CreatureCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "\(CreatureCollectionViewCell.self)"
    
    @IBOutlet var imageView: UIImageView!
    
    var creature: Dream.Creature! {
        didSet {
            imageView.image = creature?.image
        }
    }
    
    override var isSelected: Bool {
        
        set {
            super.isSelected = newValue
            
            contentView.layer.borderWidth = newValue ? 1 : 0
            contentView.layer.borderColor = newValue ? UIColor.blue.cgColor : nil
        }
        get {
            super.isSelected
        }
    }
}
