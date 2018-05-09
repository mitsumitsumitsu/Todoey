//
//  ViewController.swift
//  Todoey
//
//  Created by Mitsuharu Enatsu on 5/8/18.
//  Copyright © 2018 Mitsuharu Enatsu. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    //MARK - Class Properties
    
    let itemArray = ["Item 1","Item 2","Item 3"]
    
    
    //MARK - viewDidLoad()
    
    override func viewDidLoad() {

        super.viewDidLoad()

    }

    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print("\(indexPath.row) : \(itemArray[indexPath.row])")
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    
}

/*
 Important Functions used in Class:

 tableView
    tableView(...numberOfRowsInSection
    tableView(...cellForRowAt indexPath
    .didSelectRowAt indexPath
    .deselectRow
        - When tap on row, momentarily highlight the row only. Not permanent
    .cellForRow(at..)
    .cellForRow(at..)?.accessoryType
 
 UITableViewCell
    reuseIdentifier
    textLabel?.text
 
 */
