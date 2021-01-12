//
//  Dream.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/12.
//

import SpriteKit

struct Dream: Equatable {
    
    enum Creature: Equatable {
        
        enum UnicornColor: String {
            case yellow, pink, white
        }
        
        case unicorn(UnicornColor)
        case crusty
        case shark
        case dragon
        
        var image: UIImage {
            
            let name: String
            
            switch self {
                case .unicorn(.yellow):
                    name = "\(self)-yellow"
                case .unicorn(.pink):
                    name = "\(self)-pink"
                case .unicorn(.white):
                    name = "\(self)-white"
                default:
                    name = "\(self)"
            }
            
            return UIImage(named: name)!
        }
        
        var name: String {
            switch self {
                case .unicorn(.yellow): return "Yellow \(self)"
                case .unicorn(.pink): return "Pink \(self)"
                case .unicorn(.white): return "White \(self)"
                default: return "\(self)".capitalized
            }
        }
        
        static let all: [Creature] = [
            .unicorn(.yellow),
            .unicorn(.pink),
            .unicorn(.white),
            .crusty,
            .shark,
            .dragon
        ]
    }
    
    enum Effect {
        case fireBreathing
        case laserFocus
        case magic
        case fireflies
        case rain
        case snow
        
        var resourceName: String {
            
            let caseName = "\(self)"
            
            let secondIndex = caseName.index(after: caseName.startIndex)
            let filePrefix = caseName[..<secondIndex].uppercased() + caseName[secondIndex..<caseName.endIndex]
            
            return filePrefix + "Particle"
        }
        
        static let all: [Effect] = [
            .fireBreathing,
            .laserFocus,
            .magic,
            .fireflies,
            .rain,
            .snow
        ]
        
        func makeNode() -> SKNode {
            
            let node = SKEmitterNode(fileNamed: resourceName)!
            
            if self == .fireBreathing {
                node.run(.repeatForever(.sequence([
                    .run({
                        node.particleBirthRate = 300
                    }),
                    .wait(forDuration: 0.35),
                    .run({
                        node.particleBirthRate = 0
                    }),
                    .wait(forDuration: 0.75)
                ])))
            }
            
            return node
        }
    }
    
    var description: String
    var creature: Creature
    var effects: Set<Effect>
    var numberOfCreatures: Int
    
    init(description: String, creature: Creature, effects: Set<Effect>, numberOfCreatures: Int = 1) {
        self.description = description
        self.creature = creature
        self.effects = effects
        self.numberOfCreatures = numberOfCreatures
    }
}

func ==(_ lhs: Dream.Creature, _ rhs: Dream.Creature) -> Bool {
    
    switch (lhs, rhs) {
        
        case let (.unicorn(lhsUnicorn), .unicorn(rhsUnicorn)):
            return lhsUnicorn == rhsUnicorn
        case (.crusty, .crusty), (.shark, .shark), (.dragon, .dragon):
            return true
            
        default:
            return false
    }
}

func ==(_ lhs: Dream, _ rhs: Dream) -> Bool {
    
    return  lhs.description == rhs.description &&
            lhs.creature == rhs.creature &&
            lhs.effects == rhs.effects &&
            lhs.numberOfCreatures == rhs.numberOfCreatures
}
