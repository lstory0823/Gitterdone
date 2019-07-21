//
//  Category.swift
//  Gitterdone
//
//  Created by Liam Story on 7/19/19.
//  Copyright © 2019 Liam Story. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    
    @objc dynamic var name : String = ""
    let items = List<Item>()
    
}
