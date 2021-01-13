//
//  CollectionViewHeaderReusableView.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/13.
//

import UIKit

class CollectionViewHeaderReusableView: UICollectionReusableView {
    
    static let reuseIdentifier = "\(CollectionViewHeaderReusableView.self)"
    
    @IBOutlet var label: UILabel?
    
    var title: String = "" {
        didSet (newValue) {
            label?.text = newValue
        }
    }
}
