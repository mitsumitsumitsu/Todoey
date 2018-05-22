//
//  ViewController.swift
//  Todoey
//
//  Created by Mitsuharu Enatsu on 5/8/18.
//  Copyright © 2018 Mitsuharu Enatsu. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    //MARK - Class Properties
    
    var todoItems : Results<Item>?
    
    let realm = try! Realm()

    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }

    
    // IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //MARK - viewDidLoad()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            // Just to get a path for where the data is being stored in our app
    }

    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        print("cellForRowAt indexPath called")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        if let item = todoItems?[indexPath.row] {
            // if todoItems is not nil, then grab the item at indexPath.row
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done == true ? .checkmark : .none
                // Ternary Operator: Value = condition ? valueIfTrue : valueIfFalse
        } else {
            cell.textLabel?.text = "No Items Added"
        }

        return cell
    }
    
    
    // MARK - TableView Delegate Methods
    
    // tableView(... didSelectRowAt indexPath:) **********
    // Update the done attribute of an item
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                    // item.done = !item.done
                }
            } catch {
                print("Error saving done status: \(error)")
            }
        }
        
        tableView.reloadData()
    }
    
    
    // Mark - Add New List Items
    
    // addButtonPressed() **********
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("some fucking error: \(error)")
                }
            }
            
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
    
    
    // MARK - Model Manipulation Methods
    

    // saveItems() **********
    // Commit context to permanent storage inside persistentContainer
    
    
    // loadItems() **********
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }

}


// Mark: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            // Update todoItems to equals todoItems filtered by this predicate
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }


}







/* Notes:

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
 
 
 Deleted Code:
 
 // let encoder = PropertyListEncoder() - Commented out because you no longer need the encoder. You will be using Data Core and SQLite
 //
 // do {
 // let data = try encoder.encode(itemArray)
 // try data.write(to: dataFilePath!)
 // } catch {
 // print("Error encoding item array: \(error) ")
 // print(error)
 // }
 
 
 
 */
