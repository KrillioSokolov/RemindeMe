//
//  SKAllListController.swift
//  SKChecklist
//
//  Created by Kirill on 10.01.17.
//  Copyright © 2017 Kirill. All rights reserved.
//

import UIKit

class SKAllListController: UITableViewController, SKListDetailControllerDelegate, UINavigationControllerDelegate {

    var dataModel: SKDataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        
        if index >= 0 && index < dataModel.lists.count {
            
            let checklist = dataModel.lists[index]
            
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }


    //MARK: - SKListcontroller Delegate
    
    func listDetailControllerDidCancel(_ controller: SKListDetailController) {
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailController(_ controller: SKListDetailController, didFinishAdding checklist: SKChecklist) {
        
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        
        tableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailController(_ controller: SKListDetailController, didFinishEditing checklist: SKChecklist) {
        
        dataModel.sortChecklists()
        
        tableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = makeCell(for: tableView)
        
        let checklist = dataModel.lists[indexPath.row]
        
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        cell.imageView!.image = UIImage(named: checklist.iconName)
        
        let count = checklist.uncheckedItems()
        
        
        if checklist.items.count == 0 {
            
            cell.detailTextLabel!.text = "(No Items)"
        } else if count == 0 {
            cell.detailTextLabel!.text = "All Done!"
        } else {
            cell.detailTextLabel!.text = "\(checklist.items.count - count)/\(checklist.items.count)  Alredy Done"
        }
        return cell
    }
    
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            
            return cell
            
        } else {
            
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dataModel.indexOfSelectedChecklist = indexPath.row
        
         let checklist = dataModel.lists[indexPath.row]
        
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowChecklist" {
            
            let controller = segue.destination as! SKChecklistController
            
            controller.checklist = sender as! SKChecklist // transfering object.
        } else if segue.identifier == "AddChecklist" {
            
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! SKListDetailController
            
            controller.delegate = self
            controller.checklistToEdit = nil
        }
    }
    
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        dataModel.lists.remove(at: indexPath.row)
    
        let indexPathes = [indexPath]
    
        tableView.deleteRows(at: indexPathes, with: .automatic)
        
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "SKListDetailNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! SKListDetailController
        
        controller.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        
        controller.checklistToEdit = checklist
        
        present(navigationController, animated: true, completion: nil)
    }
    
    //MARK: - Navigation Controller
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
}
