//
//  SKDataModel.swift
//  SKChecklist
//
//  Created by Kirill on 11.01.17.
//  Copyright © 2017 Kirill. All rights reserved.
//

import Foundation



class SKDataModel {
    
    var lists = [SKChecklist]()
    var items = [SKChecklistItem]()
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
       
    }
    
    
    
    func documetsDirectory() -> URL {
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return path[0]
    }
    
    func dataFilepPath() -> URL {
        return documetsDirectory().appendingPathComponent("Checklist.plist")
    }
    
    func saveChecklists() {
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        archiver.encode(lists, forKey: "Checklists")
        archiver.finishEncoding()
        
        data.write(to: dataFilepPath(), atomically: true)
    }
    
    func loadChecklists() {
        
        let path = dataFilepPath()
        
        if let data = try? Data(contentsOf: path) {
            
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            
            lists = unarchiver.decodeObject(forKey: "Checklists") as! [SKChecklist]
            
            unarchiver.finishDecoding()
            
            sortChecklists()
        }

    }
    
    class func nextChecklistItemID() -> Int {
        
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        
        return itemID
    }
    
    func handleFirstTime() {
        
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            
            let checklist = SKChecklist(name: "List")
            
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
        
    }
    
    func registerDefaults() {
        
        let dictionary: [String : Any] = ["ChecklistIndex": -1, "FirstTime": true, "ChecklistItemID": 0]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func sortChecklists() {
        print(lists)
        lists.sort(by: { (checklist1, checklist2) -> Bool in
            return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending
        })
        print(lists)
    }
}
