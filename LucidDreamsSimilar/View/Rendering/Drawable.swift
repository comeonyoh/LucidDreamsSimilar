//
//  Drawable.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/12.
//
import UIKit
import CoreGraphics

protocol Drawable {
    func draw(in context: CGContext)
}

struct ImageDrawable: Layout, Drawable {

    var image: UIImage
    var frame: CGRect
        
    mutating func layout(in rect: CGRect) {
        frame = rect
    }
    
    func draw(in context: CGContext) {
        UIGraphicsPushContext(context)
        image.draw(in: frame)
        UIGraphicsPopContext()
    }
    
    typealias Content = Drawable
    var contents: [Drawable] {
        [self]
    }
}

struct TextDrawable: Layout, Drawable {

    var text: String
    var frame: CGRect
    
    mutating func layout(in rect: CGRect) {
        frame = rect
    }
    
    func draw(in context: CGContext) {
        UIGraphicsPushContext(context)
        let attributed = NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 40)
        ])
        var frame = self.frame
        let height = min(attributed.size().height, frame.size.height)
        frame.origin.y += 0.5 * frame.size.height - height
        frame.size.height = height
        attributed.draw(in: frame)
        UIGraphicsPopContext()
    }
    
    typealias Content = Drawable
    var contents: [Drawable] {
        [self]
    }
}
