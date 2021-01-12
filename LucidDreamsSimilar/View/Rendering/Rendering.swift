//
//  Rendering.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/12.
//

import UIKit

private func makeImage(from dream: Dream) -> UIImage {
    
    let size = CGSize(width: 500, height: 200)
    UIGraphicsBeginImageContext(size)
    
    defer { UIGraphicsEndImageContext() }
    
    let context = UIGraphicsGetCurrentContext()!
    
    let content = TextDrawable(text: dream.description, frame: .zero)
    let decoration = ImageDrawable(image: dream.creature.image, frame: .zero)
    let accessories = Array(repeatElement(decoration, count: dream.numberOfCreatures))
    
    var multiPaneLayout = MultiPaneLayout(content: content, accessories: accessories)
    multiPaneLayout.layout(in: CGRect(origin: .zero, size: size))
    
    let drawables = multiPaneLayout.contents
    for drawable in drawables {
        drawable.draw(in: context)
    }
    
    return UIGraphicsGetImageFromCurrentImageContext()!
}

func makeImages(from dreams: [Dream], completion: @escaping ([UIImage]) -> Void) {
    
    let backgroundQueue = DispatchQueue(label: "background.render")
    
    backgroundQueue.async {
        
        let images = dreams.map {
            makeImage(from: $0)
        }
        
        DispatchQueue.main.async {
            completion(images)
        }
    }
}
