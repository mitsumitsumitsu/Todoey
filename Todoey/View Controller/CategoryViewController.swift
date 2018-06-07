//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mitsuharu Enatsu on 5/16/18.
//  Copyright © 2018 Mitsuharu Enatsu. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    // Global Variables and Constants
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    
    // Mark: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    
    // MARK: - TableView DataSource Methods
    // Set up the datasource to display all categories that are stored in the Persistent Container
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // Taps into the cell that is created insie the Super View (It is the super class SwipeTableCell that handles the cell actions)

        if let category = categories?[indexPath.row] {
            
            cell.textLabel?.text = category.name ?? "No categories added yet"
            
            cell.backgroundColor = UIColor(hexString: category.color ?? "1D9BF6")
            
        }
        
        tableView.separatorStyle = .none
        
        return cell
    }
        // So when this method it called, the first thing it does is since wse called Super, it goes into the superclass and triggers the code inside cellForRowAt indexPath
                // This method will create a new cell, from the prototype "Cell" and is created as a SwipeTableViewCell
    
    
    // MARK: - Data Manipulation Methods

    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context : \(error)")
        }
        print("Save Category successful")
        self.tableView.reloadData()
    }
    

    func loadCategories() {
        categories = realm.objects(Category.self)
        print("loadCategories() called")
        tableView.reloadData()
    }
    
    
    // MARK: Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        // You can call original updateModel func by saying super.updateModel(at: indexPath)
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do  {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category: \(error)")
            }
        }
    }
        // override the updateModel function from SwipeTableViewController
    
    
    // MARK: - Add New Categories
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            
            newCategory.color = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("didSelectRowAt")
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
                // Need to create the property selectedVategory in the ToDoListCOntroller
        }
            // The indexPath that will indicate the current row that is selected
    }
    
    
}



/*
 let newCategory = Category(context: self.context)
    - let newItem = Item(context: NSManagedObjectContext)
    - context - context where this item is going to exist. The view context of our persistent container
 
 func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
    -  .. = Item.fetchRequest() will serve as a default value, incase no other request is put as a parameter
 
 
 Realm
    .object
        Return type is of Results<Element> that comes from RealmSwift
 
 cell.backgroundColor = UIColor.randomFlat
    - Generates a random color
 
 cell.backgroundColor = UIColor(hexString: "someStringOfHex")
 
 
 */

