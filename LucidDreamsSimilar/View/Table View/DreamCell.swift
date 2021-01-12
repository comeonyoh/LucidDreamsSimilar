//
//  DreamCell.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/13.
//

import UIKit

class DreamCell: UITableViewCell {
    
    static let reuseIdentifier = "\(DreamCell.self)"
    
    var content = UILabel()
    var accessories = [UIImageView]()
    
    var dream: Dream! {
        
        didSet {
            accessories = (0..<dream.numberOfCreatures).map({ _ in
                let imageView = UIImageView(image: dream.creature.image)
                imageView.contentMode = .scaleAspectFit
                return imageView
            })
            
            content.text = dream.description
            for subview in contentView.subviews {
                subview.removeFromSuperview()
            }
            
            addSubviews()
            setNeedsLayout()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        let multiPaneLayout = MultiPaneLayout(content: content, accessories: accessories)
        for view in multiPaneLayout.contents {
            contentView.addSubview(view)
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        var multiPaneLayout = MultiPaneLayout(content: content, accessories: accessories)
        multiPaneLayout.layout(in: contentView.bounds)
    }
}
