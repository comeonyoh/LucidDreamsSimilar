//
//  CreatureCell.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/13.
//

import UIKit

class CreatureCell: UITableViewCell {
    
    static let reuseIdentifier = "\(CreatureCell.self)"
    
    private var content = UILabel()
    private var decoration = UIImageView()
    
    var creature: Dream.Creature! {
        didSet {
            decoration.image = creature.image
        }
    }
    
    var title = "" {
        didSet {
            content.text = title
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        decoration.contentMode = .scaleAspectFit
        
        let decoratingLayout = DecoratingLayout(content: content, decoration: decoration)
        for view in decoratingLayout.contents {
            contentView.addSubview(view)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        var decoratingLayout = DecoratingLayout(content: content, decoration: decoration)
        decoratingLayout.layout(in: contentView.bounds)
    }
}
