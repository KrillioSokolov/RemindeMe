//
//  SKChecklist.swift
//  SKChecklist
//
//  Created by Kirill on 10.01.17.
//  Copyright © 2017 Kirill. All rights reserved.
//

import UIKit

class SKChecklist: NSObject, NSCoding {
    
    var name = ""
    var items = [SKChecklistItem]()
    var iconName: String
    
    init(name: String, iconName: String) {
        
        self.name = name
        self.iconName = "No Icon"
        
        super.init()
    }
    
    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
    
    required init?(coder deCoder: NSCoder){
        
        items = deCoder.decodeObject(forKey: "Items") as! [SKChecklistItem]
        name = deCoder.decodeObject(forKey: "Name") as! String
        iconName = deCoder.decodeObject(forKey: "IconName") as! String
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(items, forKey: "Items")
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(iconName, forKey: "IconName")
    
    }
    
    func uncheckedItems() -> Int {
        
        var count = 0
        
        for item in items {
            if !item.checked {
                count += 1
            }
        }
         return count
    }
}
