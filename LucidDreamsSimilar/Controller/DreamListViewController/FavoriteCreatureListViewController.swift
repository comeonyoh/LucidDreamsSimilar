//
//  FavoriteCreatureListViewController.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/13.
//

import UIKit

class FavoriteCreatureListViewController: UITableViewController {

    var favoriteCreatureDidChange: ((Dream.Creature) -> Void)?

    var favoriteCreature: Dream.Creature!
    
    func withFavoriteCreature(_ mutateFavoriteCreature: (inout Dream.Creature) -> Void) {
        
        let old = favoriteCreature
        
        mutateFavoriteCreature(&favoriteCreature)
        
        guard favoriteCreature != old else {
            
            if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
            }
            
            return
        }
        
        tableView.beginUpdates()

        if let old = old {
            let indexOfPreviousFavoriteCreature = Dream.Creature.all.firstIndex(of: old)!
            let indexPathOfPreviousFavoriteCreature = IndexPath(row: indexOfPreviousFavoriteCreature, section: 0)
            tableView.deselectRow(at: indexPathOfPreviousFavoriteCreature, animated: true)
            let previousFavoriteCreatureCell = tableView.cellForRow(at: indexPathOfPreviousFavoriteCreature)
            previousFavoriteCreatureCell?.accessoryType = .none
        }
        
        let indexOfNewFavoriteCreature = Dream.Creature.all.firstIndex(of: favoriteCreature!)!
        let indexPathOfNewFavoriteCreature = IndexPath(row: indexOfNewFavoriteCreature, section: 0)
        tableView.deselectRow(at: indexPathOfNewFavoriteCreature, animated: true)
        
        let newFavoriteCreatureCell = tableView.cellForRow(at: indexPathOfNewFavoriteCreature)
        newFavoriteCreatureCell?.accessoryType = .checkmark
        
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Dream.Creature.all.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let creature = Dream.Creature.all[indexPath.row]
        
        cell.accessoryType = creature == favoriteCreature ? .checkmark : .none
        
        cell.imageView!.image = creature.image
        cell.textLabel!.text = creature.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        withFavoriteCreature { newFavoriteCreature in
            newFavoriteCreature = Dream.Creature.all[indexPath.row]
        }
    }
    
    @IBAction func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped() {
        favoriteCreatureDidChange?(favoriteCreature)
        dismiss(animated: true, completion: nil)
    }
}
