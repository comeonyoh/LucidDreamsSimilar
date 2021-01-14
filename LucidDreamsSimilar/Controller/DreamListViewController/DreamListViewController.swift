//
//  DreamListViewController.swift
//  LucidDreamsSimilar
//
//  Created by JungSu Kim on 2021/01/12.
//

import UIKit

class DreamListViewController: UITableViewController {

    typealias Model = DreamListViewControllerModel
    
    enum SegueIdentifier: String {
        case showDetail = "showDetail"
        case pickFavoriteCreature = "showFavoriteCreaturePicker"
    }
    
    enum Section: Int, CaseIterable {
        case favoriteCreature = 0
        case dreams = 1
        
        init(at indexPath: IndexPath) {
            self.init(rawValue: indexPath.section)!
        }
        
        init(_ section: Int) {
            self.init(rawValue: section)!
        }
        
        static let count = Section.allCases.count
        
        var title: String {
            
            switch self {
                case .favoriteCreature:
                    return "Favorite Creature"
                case .dreams:
                    return "Dreams"
            }
        }
    }
    
    var state = State.viewing
    var model = Model.initial

    let _undoManager = UndoManager()
    
    override var undoManager: UndoManager? {
        get {
            _undoManager
        }
    }
    
    func withValues(_ mutations: (inout Model, inout State) -> Void) {
        
        let oldModel = self.model
        
        mutations(&self.model, &self.state)
        
        tableView.beginUpdates()
        
        modelDidChange(diff: oldModel.diffed(with: self.model))
        stateDidChange()

        tableView.endUpdates()
    }
    
    private func modelDidChange(diff: Model.Diff) {
        
        if diff.hasAnyDreamChanges {
            
            switch diff.dreamChange {
                case .inserted?:
                    tableView.insertRows(at: [IndexPath(row: diff.from.dreams.count, section: Section.dreams.rawValue)],
                                         with: .automatic)
                    
                case .removed(_)?:
                    tableView.deleteRows(at: [IndexPath(row: diff.from.dreams.count - 1, section: Section.dreams.rawValue)],
                                         with: .automatic)
                
                case .updated(let indexes)?:
                    let indexPaths = indexes.map {
                        IndexPath(row: $0, section: Section.dreams.rawValue)
                    }
                    tableView.reloadRows(at: indexPaths, with: .automatic)
                    break
                    
                default:
                    break
            }
        }
        
        if diff.favoriteCreatureChanged {
            tableView.reloadSections(IndexSet(integer: Section.favoriteCreature.rawValue), with: .automatic)
        }
        
        if diff.hasAnyChanges {
            undoManager?.registerUndo(withTarget: self, handler: { target in
                
                target.withValues { model, _ in
                    model = diff.from
                }
            })
        }
    }
    
    private func stateDidChange() {
        
        let editing: Bool
        let rightBarItem: (UIBarButtonItem.SystemItem, enabled: Bool)?
        
        enum LeftBarButton {
            case cancel
            case duplicate
        }
        
        let leftBarButton: LeftBarButton?
        
        switch state {
            case .viewing:
                editing = false
                leftBarButton = .duplicate
                rightBarItem = (.action, enabled: true)
                
            case let .selecting(selectedRow):
                editing = true
                leftBarButton = .cancel
                rightBarItem = (.done, enabled: !selectedRow.isEmpty)
                
            case let .sharing(dreams):
                editing = false
                leftBarButton = nil
                rightBarItem = (.action, enabled: true)
                
                if dreams.isEmpty {
                    
                    withValues { (_, state) in
                        state = .viewing
                    }
                    return
                }
                else {
                    share(dreams, completion: {
                        
                        self.withValues { _, state in
                            state = .viewing
                        }
                    })
                }
                
            case .duplicating:
                editing = false
                leftBarButton = .cancel
                rightBarItem = nil
        }
        
        for indexPath in tableView.indexPathsForVisibleRows ?? [] {
            
            if let cell = tableView.cellForRow(at: indexPath) {
                
                let section = Section(at: indexPath)
                switch section {
                    case .favoriteCreature:
                        if let creatureCell = cell as? CreatureCell {
                            configureCreatureCell(creatureCell, at: indexPath)
                        }
                        
                    case .dreams:
                        if let dreamCell = cell as? DreamCell {
                            configureDreamCell(dreamCell, at: indexPath)
                        }
                }
                
                if cell.isSelected {
                    if case .selecting = state {
                        
                    }
                    else {
                        tableView.deselectRow(at: indexPath, animated: true)
                    }
                }
            }
        }
        
        let rightBarButtonItem = rightBarItem.map { barItem, enabled -> UIBarButtonItem in
            
            let barButtonItem = UIBarButtonItem(barButtonSystemItem: barItem, target: self, action: #selector(DreamListViewController.toggleSelectingRows))
            
            barButtonItem.isEnabled = enabled
            return barButtonItem
        }
        
        navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
        
        let leftBarButtonItem = leftBarButton.map { leftBarButton -> UIBarButtonItem in
            
            switch leftBarButton {
                
                case .cancel:
                    return UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(DreamListViewController.goBackToViewingState))
                    
                case .duplicate:
                    return UIBarButtonItem(title: "Duplicate", style: .plain, target: self, action: #selector(DreamListViewController.startDuplicating))
            }
        }
        
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
        setEditing(editing, animated: true)
        
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(state.plistRepresentation, forKey: "state")
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        if let representation = coder.decodeObject(forKey: "state"),
           var newState = State(plistRepresentation: representation) {
            newState.validateWithModel(model: model)
            withValues { _, state in
                state = newState
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resignFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool {
        true
    }
    
    override func viewDidLoad() {
        stateDidChange()
        
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(CreatureCell.self, forCellReuseIdentifier: CreatureCell.reuseIdentifier)
        tableView.register(DreamCell.self, forCellReuseIdentifier: DreamCell.reuseIdentifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        Section.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(section) {
            case .favoriteCreature: return 1
            case .dreams: return model.dreams.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Section(section).title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section(at: indexPath)
        switch section {
            case .favoriteCreature:
                let cell = tableView.dequeueReusableCell(withIdentifier: CreatureCell.reuseIdentifier, for: indexPath) as! CreatureCell
                configureCreatureCell(cell, at: indexPath)
                return cell
                
            case .dreams:
                let cell = tableView.dequeueReusableCell(withIdentifier: DreamCell.reuseIdentifier, for: indexPath) as! DreamCell
                configureDreamCell(cell, at: indexPath)
                return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = Section(at: indexPath)
        
        switch (section, state) {
            case (.favoriteCreature, .viewing):
                performSegue(withIdentifier: SegueIdentifier.pickFavoriteCreature.rawValue, sender: nil)
                
            case (.dreams, _):
                handleDreamTap(at: indexPath)
                
            default:
                break
        }
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let section = Section(at: indexPath)
        if case .selecting = state, section == .dreams {
            handleDreamTap(at: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let section = Section(at: indexPath)
        switch section {
            case .favoriteCreature: return false
            case .dreams: return true
        }
    }
    
    func handleDreamTap(at indexPath: IndexPath) {
        let row = indexPath.row
        
        switch state {
            case .sharing:
                break
            
            case .viewing:
                performSegue(withIdentifier: SegueIdentifier.showDetail.rawValue, sender: nil)
                
            case let .selecting(selectedrows):
                let combinedRows: IndexSet
                
                if selectedrows.contains(row) {
                    combinedRows = selectedrows.subtracting([row])
                }
                else {
                    combinedRows = selectedrows.union([row])
                }
                
                withValues { _, state in
                    state = .selecting(selectedRow: combinedRows)
                }
                
            case .duplicating:
                withValues { (model, state) in
                    var selectedDream = model.dreams[indexPath.row]
                    selectedDream.description += " (copy)"
                    model.append(selectedDream)
                    
                    state = .viewing
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier.flatMap(SegueIdentifier.init) else {
            return
        }
        
        let selectedDreamIndex = tableView.indexPathForSelectedRow!.row
        
        switch identifier {
            case .showDetail:
                let detailViewController = segue.destination as! DreamDetailViewController
                detailViewController.dream = model.dreams[selectedDreamIndex]

                detailViewController.dreamDidChange = { [weak self] newDream in
                    guard let strongSelf = self else { return }

                    strongSelf.withValues { model, _ in
                        model[dreamAt: selectedDreamIndex] = newDream
                    }
                }

            case .pickFavoriteCreature:
                let navigationController = segue.destination as! UINavigationController
                let detailViewController = navigationController.viewControllers.first! as! FavoriteCreatureListViewController

                detailViewController.favoriteCreature = model.favoriteCreature
                detailViewController.favoriteCreatureDidChange = { [weak self] newFavoriteCreature in
                    guard let strongSelf = self else { return }

                    strongSelf.withValues { model, _ in
                        model.favoriteCreature = newFavoriteCreature
                    }
            }
        }
    }
    
    func configureCreatureCell(_ cell: CreatureCell, at indexPath: IndexPath) {
        
        let creature = model.favoriteCreature
        let selectionStyle: UITableViewCell.SelectionStyle
        
        if case .viewing = state {
            selectionStyle = .default
        }
        else {
            selectionStyle = .none
        }
        
        cell.selectionStyle = selectionStyle
        cell.creature = creature
        cell.title = creature.name
    }
    
    func configureDreamCell(_ cell: DreamCell, at indexPath: IndexPath) {
        
        let accessoryType: UITableViewCell.AccessoryType
        switch state {
            case .duplicating:
                accessoryType = .none
            
            case .viewing, .sharing:
                accessoryType = .disclosureIndicator
                
            case .selecting:
                accessoryType = .none
        }
        
        cell.accessoryType = accessoryType
        cell.dream = model.dreams[indexPath.row]
    }

    @objc func toggleSelectingRows() {
        
        let newState: State
        
        switch state {
            case .viewing:
                newState = .selecting(selectedRow: [])
                
            case let .selecting(selectedRows):
                
                let selectedDreams = model.dreams[selectedRows]
                newState = .sharing(dreams: selectedDreams)
            
            case .sharing, .duplicating:
                fatalError("Shouldn't get in this state.")
        }
        
        withValues { _, state in
            state = newState
        }
    }
    
    @objc func goBackToViewingState() {
        withValues {
            _, state in state = .viewing
        }
    }
    
    @objc func startDuplicating() {
        withValues {
            _, state in state = .duplicating
        }
    }
    
    func share(_ dreams: [Dream], completion: @escaping () -> Void) {
        
        if presentingViewController == nil {
            
            view.isUserInteractionEnabled = false
            
            makeImages(from: dreams) { [weak self] images in
                
                guard let strongSelf = self else  { return }
                
                strongSelf.view.isUserInteractionEnabled = true
                
                let activityViewController = UIActivityViewController(activityItems: images, applicationActivities: [])
                activityViewController.completionWithItemsHandler = { _, _, _, _ in
                    completion()
                }
                
                strongSelf.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
}

extension RangeReplaceableCollection where Index == Int {
    
    subscript(indexes: IndexSet) -> Self {
        
        var new = Self()
        
        new.reserveCapacity(indexes.count)
        
        for idx in indexes {
            new.append(self[idx])
        }
        
        return new
    }
}
