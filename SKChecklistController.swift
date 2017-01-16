//
//  SKChecklistController.swift
//  SKChecklist
//
//  Created by Kirill on 21.12.16.
//  Copyright © 2016 Kirill. All rights reserved.
//

import UIKit


class SKChecklistController: UITableViewController, SKItemDetailControllerDelegate {
    
    var checklist: SKChecklist!
    var dataModel = SKDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = checklist.name
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    
    
    //MARK: - SKCheklist item
    
    func configureCheckmark(for cell: UITableViewCell, with item: SKChecklistItem) {
        
        let label = cell.viewWithTag(1001) as! UILabel
        
        label.textColor = view.tintColor
        
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }

    
    func configureText(for cell: UITableViewCell, with item: SKChecklistItem) {
        
        let label = cell.viewWithTag(1000)! as! UILabel
        
        label.text = item.text
    }
    
    
    func configurateSubtitle(for cell: UITableViewCell, with item: SKChecklistItem, and bool: Bool) {
    
        let label = cell.viewWithTag(1003)! as! UILabel
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        if bool{
            label.text = "Remind me in \(formatter.string(from: item.dueDate))"
        }else{
            label.text = "Without reminders"
        }
    
    }
    
    
    //MARK: - SKItemDetailController Delegate
    
    func itemDetailControllerDidCancel(_ controller: SKItemDetailController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailController(_ controller: SKItemDetailController, didFinishEditing item: SKChecklistItem) {
        
        if let index = checklist.items.index(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            
            if let cell = tableView.cellForRow(at: indexPath){
        
        
                configureText(for: cell, with: item)
                configurateSubtitle(for: cell, with: item, and: item.shouldRemind)
            }
            dismiss(animated: true, completion: nil)
            
        }
    }
    
    func itemDetailController(_ controller: SKItemDetailController, didFinishAdding item: SKChecklistItem) {
        
        let newRowIndex = checklist.items.count
        
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPathes = [indexPath]
        
        tableView.insertRows(at: indexPathes, with: .automatic)
        
        dismiss(animated: true, completion: nil)
        
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = checklist.items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        configurateSubtitle(for: cell, with: item, and: item.shouldRemind)
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let item = checklist.items[indexPath.row]
            
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }

        tableView.deselectRow(at: indexPath, animated: true)
       
        
    }


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        checklist.items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
      
        }    
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem"{
        
            let navigationController = segue.destination as! UINavigationController // first you get ahold of this UINavigationController object
        
            let controller = navigationController.topViewController as! SKItemDetailController // this property refers to the screen that is currently active inside the navigation controller.
        
            controller.delegate = self // this tells the SKItemDetailController that from now on, the object known as self(SKChecklistController) is its delegate.
        }else if segue.identifier == "EditItem"  {
        
            let navigationController = segue.destination as! UINavigationController
        
            let controller = navigationController.topViewController as! SKItemDetailController
        
                controller.delegate = self
        
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) { //unwraping   optional variable indexPath(for:)
            
                    controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
}





