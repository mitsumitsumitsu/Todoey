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
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    
    //MARK - viewDidLoad()
    
    override func viewDidLoad() {

        super.viewDidLoad()
  
        let newItem = Item()
        newItem.title = "Find Mike"
        newItem.done = true
        itemArray.append(newItem)

        let newItem2 = Item()
        newItem2.title = "Buy Eggs"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Some other task"
        itemArray.append(newItem3)
        
        // Populate array if there is data from the UserDefault plist
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
           itemArray = items
        }

    }

    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        print("cellForRowAt indexPath called")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        let item = itemArray[indexPath.row]
            
        cell.textLabel?.text = item.title
        
        // Ternary Operator: Value = condition ? valueIfTrue : valueIfFalse

        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("didSelectRowAt")
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
            // Changes current value to the opposite of what it is right now.
        
        tableView.reloadData()
            // Call datasource method again
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // Mark - Add New List Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the Add Item button on our UIAlert
            
            print("Test - Add Item press complete. Item: \(textField.text)")
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
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
    .accaccessoryType
    .reloadData()
        - This makes tableView to reload again
 
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
 
 UserDefaults
    .standard
    .set(value, forKey: )
    .array(forKey: )
 
 present(viewControllerToPresent: someViewController, animated: Bool, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
 
 */
