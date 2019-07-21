//
//  Item.swift
//  Gitterdone
//
//  Created by Liam Story on 7/19/19.
//  Copyright © 2019 Liam Story. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var completed : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
