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
        didSet {
            label?.text = title
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.label?.frame = .init(x: 10, y: 0, width: self.bounds.width - 20, height: self.bounds.height)
    }
}
