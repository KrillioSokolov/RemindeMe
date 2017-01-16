//
//  SKChecklistItem.swift
//  SKChecklist
//
//  Created by Kirill on 27.12.16.
//  Copyright © 2016 Kirill. All rights reserved.
//

import Foundation
import UserNotifications

class SKChecklistItem: NSObject, NSCoding {

    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    
    override init() {
        
        itemID = SKDataModel.nextChecklistItemID()

        super.init()
    }
    
    
    func toggleChecked() {
        checked = !checked
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
        aCoder.encode(dueDate, forKey: "DueDate")
        aCoder.encode(shouldRemind, forKey: "ShouldRemid")
        aCoder.encode(itemID, forKey: "ItemID")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        itemID = aDecoder.decodeInteger(forKey: "ItemID")
        
        super.init()
    }
    
    func scheduleNotification() {
        
        removeNotification()
        
        if shouldRemind && dueDate > Date() {
            
            let content = UNMutableNotificationContent()
            
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default()
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
       
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
        
            center.add(request)
        
        }
    }
    
    func removeNotification() {
        
        let center = UNUserNotificationCenter.current()
        
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
    deinit {
        removeNotification()
    }
}

