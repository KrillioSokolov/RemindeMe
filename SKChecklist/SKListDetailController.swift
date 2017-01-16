//
//  SKListDetailController.swift
//  SKChecklist
//
//  Created by Kirill on 11.01.17.
//  Copyright © 2017 Kirill. All rights reserved.
//

import UIKit

protocol SKListDetailControllerDelegate: class {
    func listDetailControllerDidCancel(_ controller: SKListDetailController)
    func listDetailController(_ controller: SKListDetailController, didFinishAdding checklist: SKChecklist)
    func listDetailController(_ controller: SKListDetailController, didFinishEditing checklist: SKChecklist)
}



class SKListDetailController: UITableViewController, UITextFieldDelegate, SKIconPickerCotrollerDelegate {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var delegate: SKListDetailControllerDelegate?
    var checklistToEdit: SKChecklist?
    var iconName = "Folder"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let checklist = checklistToEdit {
            
            title = "Edit Checklist"
            
            textField.text = checklist.name
            
            doneButton.isEnabled = true
            
            checklist.iconName = iconName
            
            imageView.image = UIImage(named: iconName)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    
    
    @IBAction func done() {
        
        if let checklist = checklistToEdit{
            
            checklist.name = textField.text!
            checklist.iconName = iconName
            
            delegate?.listDetailController(self, didFinishEditing: checklist)
        } else {
            
            let checklist = SKChecklist(name: textField.text!, iconName: iconName)
            
            checklist.iconName = iconName
            
            delegate?.listDetailController(self, didFinishAdding: checklist)
        }
        
    }
    
    @IBAction func cancel() {
        delegate?.listDetailControllerDidCancel(self)
    }
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneButton.isEnabled = newText.length > 0
        
        return true
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }

    // MARK: - Navigation
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
            if segue.identifier == "PickIcon" {
                
                let controller = segue.destination as! SKIconPickerCotroller
                
                controller.delegate = self
            }
    }
    
    //MARK: - SKIconPickerControllerDelegate
    
    func iconPicker(_ picker: SKIconPickerCotroller, didPick iconName: String) {
        
        self.iconName = iconName
        imageView.image = UIImage(named: iconName)
        
        let _ = navigationController?.popViewController(animated: true) // tell Xcode I'm don’t care about the return value from popViewController() – without this let Xcode gives a warning
    }

}

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
 
*/
