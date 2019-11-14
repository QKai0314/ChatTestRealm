//
//  Item.swift
//  ChatTestRealm
//
//  Created by Kai Qiao on 11/14/19.
//  Copyright © 2019 iKai0314. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var itemId: String = UUID().uuidString
    @objc dynamic var body: String = "Hi"
    @objc dynamic var isDone: Bool = false
    @objc dynamic var timestamp: Date = Date()
    
    override static func primaryKey() -> String? {
        return "itemId"
    }
    
}
