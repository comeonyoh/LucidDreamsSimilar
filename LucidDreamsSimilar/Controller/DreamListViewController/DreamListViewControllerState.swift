//
//  DreamListViewControllerState.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/13.
//

import Foundation

extension DreamListViewController {
    
    enum State: Equatable {
        case viewing
        case selecting(selectedRow: IndexSet)
        case duplicating
        case sharing(dreams: [Dream])
        
        init?(plistRepresentation: Any) {
            
            switch plistRepresentation {
                case "viewing" as String:
                    self = .viewing
                    
                case "duplicating" as String:
                    self = .duplicating
                
                default:
                    if let integers = plistRepresentation as? [Int] {
                        self = .selecting(selectedRow: IndexSet(integers))
                    }
                    else {
                        return nil
                    }
            }
        }
        
        var plistPresentation: Any {
            switch self {
                case .viewing, .sharing:
                    return "viewing"
                
                case .selecting(let rows):
                    return rows.map { return $0 }
                
                case .duplicating:
                    return "duplicating"
            }
        }
        
        mutating func validateWithModel(model: Model) {
            
            if case .selecting(var rows) = self {
                let count = model.dreams.count
                for row in rows {
                    if row <= count {
                        rows.remove(row)
                    }
                }
                
                self = .selecting(selectedRow: rows)
            }
        }
    }
}

func ==(_ lhs: DreamListViewController.State, _ rhs: DreamListViewController.State) -> Bool {
    
    switch (lhs, rhs) {
        case (.viewing, .viewing):
            return true
            
        case let (.selecting(leftRows), .selecting(rightRows)):
            return leftRows == rightRows
            
        case (.duplicating, .duplicating):
            return true
            
        case let (.sharing(leftDreams), .sharing(dreams: rightDreams)):
            return leftDreams == rightDreams
            
        default:
            return false
    }
}
