//
//  TextEntryCollectionViewCell.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/13.
//

import UIKit

class TextEntryCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "\(TextEntryCollectionViewCell.self)"
    
    @IBOutlet var textField: UITextField!
    
    override func awakeFromNib() {
        textField.addTarget(textField, action: #selector(UITextField.resignFirstResponder), for: .editingDidEndOnExit)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textField.frame = self.bounds
    }
}
