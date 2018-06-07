//
//  ViewController.swift
//  Todoey
//
//  Created by Mitsuharu Enatsu on 5/8/18.
//  Copyright © 2018 Mitsuharu Enatsu. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

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
        _ = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            // Just to get a path for where the data is being stored in our app
        tableView.separatorStyle = .none
    }

    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        print("cellForRowAt indexPath called")
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
            // You are using the cellForRowAt method in the SwipeTableViewController

        if let item = todoItems?[indexPath.row] {
            // if todoItems is not nil, then grab the item at indexPath.row
            
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage:
                (CGFloat(indexPath.row) / CGFloat(todoItems!.count))
                ) {
                
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            cell.accessoryType = item.done == true ? .checkmark : .none
                // Ternary Operator: Value = condition ? valueIfTrue : valueIfFalse
       
        } else {
            cell.textLabel?.text = "No Items Added"
        }
            // You have an OPTIONAL BINDING PYRAMID here, which is a common occurence in swift

        return cell
    }
        // (hexString: selectedCategory! - Force unwrap because you were able to unwrap selectedCategory earlier in the first place
        // UIColor(hexString: selectedCategory!.color)? - UIColor returns optional, so can do optional chaining. Darken will only occur if the value isn't nil
    
    
    // MARK - TableView Delegate Methods
    
    // tableView(... didSelectRowAt indexPath:) **********
    // Update the done attribute of an item
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    //self.realm.delete(item)
                    item.done = !item.done
                    print("Item checked / unchecked")
                }
            } catch {
                print("Error saving done status: \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do  {
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting category: \(error)")
            }
        }
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
 
 CGFloat(indexPath.row / todoItems!.count)
 --> Inner equation returns an int that is rounded up or down to whole number, so for example 0.00 becomes 0. So whatever happens, CGFloat will return a whole number, which isn't what we want since we are after gradients
 
 CGFloat(indexPath.row) / CGFloat(todoItems!.count)
 --> Returns a float
 
 
 */
