//
//  DreamListViewControllerModel.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/13.
//

import Foundation

struct DreamListViewControllerModel: Equatable {
    
    var favoriteCreature: Dream.Creature
    
    private(set) var dreams: [Dream]

    init(favoriteCreature: Dream.Creature, dreams: [Dream]) {
        self.favoriteCreature = favoriteCreature
        self.dreams = dreams
    }
    
    mutating func append(_ dream: Dream) {
        self.dreams.append(dream)
    }
    
    mutating func removeLast() -> Dream {
        self.dreams.removeLast()
    }
    
    subscript(dreamAt index: Int) -> Dream {
        get {
            self.dreams[index]
        }
        set {
            dreams[index] = newValue
        }
    }
    
    static var initial: DreamListViewControllerModel {

        return DreamListViewControllerModel(favoriteCreature: .unicorn(.pink), dreams: [

            Dream(description: "Dream 1", creature: .unicorn(.pink), effects: [.fireBreathing]),
            Dream(description: "Dream 2", creature: .unicorn(.yellow), effects: [.fireBreathing], numberOfCreatures: 2),
            Dream(description: "Dream 3", creature: .unicorn(.white), effects: [.fireBreathing], numberOfCreatures: 3)
        ])
    }
    
    struct Diff {
        enum DreamChange: Equatable {
            case inserted(Dream)
            case removed(Dream)
            case updated(at: [Int])
        }
        
        let dreamChange: DreamChange?
        let from: DreamListViewControllerModel
        let to: DreamListViewControllerModel
        let favoriteCreatureChanged: Bool
        
        init(dreamChange: DreamChange?, from: DreamListViewControllerModel, to: DreamListViewControllerModel, favoriteCreatureChanged: Bool) {
            self.dreamChange = dreamChange
            self.from = from
            self.to = to
            self.favoriteCreatureChanged = favoriteCreatureChanged
        }
        
        var hasAnyDreamChanges: Bool {
            dreamChange != nil
        }
        
        var hasAnyChanges: Bool {
            favoriteCreatureChanged || hasAnyDreamChanges
        }
    }
    
    func diffed(with other: DreamListViewControllerModel) -> Diff {
        
        let dreamChange: Diff.DreamChange?
        
        if other.dreams.count - 1 == dreams.count {
            dreamChange = .inserted(other.dreams.last!)
        }
        else if dreams.count - 1 == other.dreams.count {
            dreamChange = .removed(dreams.last!)
        }
        else if dreams.count == other.dreams.count {
            
            let updatedIndexes: [Int] = dreams.enumerated().compactMap { idx, dream in
                
                if dream != other.dreams[idx] {
                    return idx
                }
                
                return nil
            }
            
            if updatedIndexes.isEmpty {
                dreamChange = nil
            }
            
            else {
                dreamChange = .updated(at: updatedIndexes)
            }
        }
        else {
            fatalError("The dreams should never change separate from the statements above.")
        }
        
        return Diff(dreamChange: dreamChange, from: self, to: other, favoriteCreatureChanged: favoriteCreature != other.favoriteCreature)
    }
}

func ==(_ lhs: DreamListViewControllerModel, _ rhs: DreamListViewControllerModel) -> Bool {
    return lhs.favoriteCreature == rhs.favoriteCreature && lhs.dreams == rhs.dreams
}

func ==(_ lhs: DreamListViewControllerModel.Diff.DreamChange, _ rhs: DreamListViewControllerModel.Diff.DreamChange) -> Bool {
    switch (lhs, rhs) {
        case let (.inserted(lhsDream), .inserted(rhsDream)): return lhsDream == rhsDream
        case let (.removed(lhsDream), .removed(rhsDream)): return lhsDream == rhsDream
        case let (.updated(lhsIndexes), .updated(rhsIndexes)): return lhsIndexes == rhsIndexes
        default: return false
    }
}
