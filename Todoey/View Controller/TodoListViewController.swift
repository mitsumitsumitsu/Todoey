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
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // Create your own plist at the location of your dataFilePath
    
    
    //MARK - viewDidLoad()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(dataFilePath)
        
        loadItems()

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
        
        saveItems()
        
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
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            print("Test")
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK - Model Manipulation Methods

    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array: \(error) ")
            print(error)
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
                    // .self used in order to refer to the type which is an array of Item objets
            } catch {
                print("Error decoding array: \(error)")
            }
        }
        
        
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
 
 FileManager
 (An object that provides a convenient interface to the contents of the file system)
    .default
    (Returns the shared FileManager object)
        .urls(for: FileManager.SearchPathDirectory, in : FileManager.SearchPathDomaininMask)
        (userDomainMask - User's home directory. Where they'll save items associated w/ app)
            .first
            (Because this is an array, grab first item)
                .appendingPathComponent(pathComponent : String)
                (pathComponent can be named anything, just make it logical)
                (This method will create the plist file of the given file name

 PropertyListEncoder
 (In the app, this will encoder your data, the itemArray, into a plist)
    .encode(value: Encodable)
    (Can throw an error, so should enclose in a do { } catch {} block (with try)
    .write

 Data
    (contentsOf: filePath)
 
 PropertyListDecoder
    .decode(type: Decodable.Protocol, from: Data(

 
 present(viewControllerToPresent: someViewController, animated: Bool, completion:  (() -> Void)?)
 
 */
