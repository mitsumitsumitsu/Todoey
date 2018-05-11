//
//  Item.swift
//  Todoey
//
//  Created by Mitsuharu Enatsu on 5/10/18.
//  Copyright © 2018 Mitsuharu Enatsu. All rights reserved.
//

import Foundation

class Item: Codable {

    var title : String = ""
    
    var done : Bool = false

}


/*
 
Encodable
(In order for the custom object to be encodable in the document folder of the sandbox, need to conform to the class Encodable.
 (The item type is now able to encode itself into a plist or into a json. In order for the custom object to be encodablke, all its properties must be of standard data type [ie. String, Int, bool, etc])
 
 Decodable
 (So that a Class and its properties can be decoded from an external data source like a plist or a json. Need to make sure that the properties of the class are standard data type)
 
 Codable
 (Summary Encodable and Decodable)
 
 */
