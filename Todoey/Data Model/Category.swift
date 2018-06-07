//
//  Category.swift
//  Todoey
//
//  Created by Mitsuharu Enatsu on 5/20/18.
//  Copyright © 2018 Mitsuharu Enatsu. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
  
    @objc dynamic var color: String = ""
    
    let items = List<Item>()

}


