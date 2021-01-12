//
//  Dream+Diff.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/12.
//

extension Dream {
    
    struct Diff: Equatable {
        
        var creatureChange: (from: Creature, to: Creature)?
        var insertedEffect: Set<Effect>
        var removedEffect: Set<Effect>
        var descriptionChange: (from: String, to: String)?
        
        init(from: Dream, to: Dream) {
            
            creatureChange = from.creature != to.creature ? (from: from.creature, to: to.creature) : nil

            insertedEffect = to.effects.subtracting(from.effects)
            removedEffect = from.effects.subtracting(to.effects)
            
            descriptionChange = from.description != to.description ? (from: from.description, to: to.description) : nil
        }
        
        var hasChange: Bool {
            
            return creatureChange != nil
                || !insertedEffect.isEmpty
                || !removedEffect.isEmpty
                || descriptionChange != nil
        }
    }
    
    func diffed(with other: Dream) -> Diff {
        return Diff(from: self, to: other)
    }
}

func == (_ lhs: Dream.Diff, _ rhs: Dream.Diff) -> Bool {
    
    switch (lhs.creatureChange, rhs.creatureChange) {
        
        case let (lhs?, rhs?):
            if lhs.from != rhs.from || lhs.to != rhs.to { return false }
        default:
            break
    }
    
    switch (lhs.descriptionChange, rhs.descriptionChange) {
        case let (lhs?, rhs?):
            if lhs.from != rhs.from || lhs.to != rhs.to { return false }
        default:
            break
    }
    
    return lhs.insertedEffect == rhs.insertedEffect &&
           lhs.removedEffect == rhs.removedEffect
}
