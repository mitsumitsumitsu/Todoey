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
    
    var itemArray = ["Item 1","Item 2","Item 3"]
    
    
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
    
    // Mark - Add New List Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the Add Item button on our UIAlert
            
            print("Test - Add Item press complete. Item: \(textField.text)")
            
            self.itemArray.append(textField.text!)
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            print("Test")
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
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
    .reloadData()
 
 UITableViewCell
    reuseIdentifier
    textLabel?.text
 
 UIAlertController
    (title.. message.. preferredStyle)
    .addTextField { (someData) in.. }
    .addAction(action: UIAlertAction)

 UIAlertAction
    (title.. style..) { (someData) in
    someData.placeholder
 
 UITextField
    .text =
 
 present(viewControllerToPresent: someViewController, animated: Bool, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
 
 */
