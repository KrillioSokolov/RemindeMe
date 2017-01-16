//
//  SKIconPickerSwiftController.swift
//  SKChecklist
//
//  Created by Kirill on 12.01.17.
//  Copyright © 2017 Kirill. All rights reserved.
//

import UIKit

protocol SKIconPickerCotrollerDelegate: class {
    func iconPicker(_ picker: SKIconPickerCotroller, didPick iconName: String)

}

class SKIconPickerCotroller: UITableViewController {
    
    weak var delegate: SKIconPickerCotrollerDelegate?
    
    let icons = [
        "No Icon",
        "Appointments",
        "Birthdays",
        "Chores",
        "Drinks",
        "Folder",
        "Groceries",
        "Inbox",
        "Photos",
        "Trips" ]
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        let iconName = icons[indexPath.row]
        
        cell.textLabel!.text = iconName
        cell.imageView!.image = UIImage(named: iconName)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let delegate = delegate {
            
            let iconName = icons[indexPath.row]
            
            delegate.iconPicker(self, didPick: iconName)
        }
    }
}
