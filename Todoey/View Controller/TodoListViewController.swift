//
//  ViewController.swift
//  Todoey
//
//  Created by Mitsuharu Enatsu on 5/8/18.
//  Copyright © 2018 Mitsuharu Enatsu. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    //MARK - Class Properties
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    // didSet : specifies what should happen when a variable gets set with a new value
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Access a singleton as a shared Application in order to tap into the persistent container lazy variable
    
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
    
    // tableView(... didSelectRowAt indexPath:) **********
    // Update the done attribute of an item
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("didSelectRowAt")
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
            // Changes current value to the opposite of what it is right now.

        // context.delete(itemArray[indexPath.row])
        // itemArray.remove(at: indexPath.row)

        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // Mark - Add New List Items
    
    // addButtonPressed() **********
    // Add new Items to the database
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the Add Item button on our UIAlert
            
            print("Test - Add Item press complete. Item: \(textField.text)")
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
                // A singleton App instance. At the timepoint when the app is running, the shared UIApplication will correspond to the live application object
                // Tap into UIApplication class --> getting the shared singelton object, which corresponds to the current app as an object --> Tap into its delegate which has the data type of an optional UIApplication delegate --> cast into our class AppDelegate because they both inherit from the same super class UIApplication delegate --> (Now we have access to our app delegate as an object) --> Now can tap into its property called persistentContainer --> Grab the viewContext of that persistent container
            
            
            let newItem = Item(context: self.context)
                // let newItem = Item(context: NSManagedObjectContext)
                // context - contexrt where this item is going to exist. The view context of our persistent container
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
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
    

    // saveItems() **********
    // Commit context to permanent storage inside persistentContainer

    func saveItems(){
        
        do {
            try context.save()
        } catch {
            print("Error saving context : \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    // loadItems() **********
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        // .. = Item.fetchRequest() will serve as a default value, incase no other request is put as a parameter
        // predicate: whatever search query we want to make in order to load items. (This was added as part of coding for the segue from Category to item list
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        // let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
        
        //request.predicate = predicate
            // Add the predicate to the request
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }

}


// Mark: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
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
