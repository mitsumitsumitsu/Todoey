//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mitsuharu Enatsu on 5/16/18.
//  Copyright © 2018 Mitsuharu Enatsu. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {

    // Global Variables and Constants
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // See notes at the bottom
    
    
    // Mark - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    
    // MARK: - TableView DataSource Methods
    // Set up the datasource to display all categories that are stored in the Persistent Container
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("cellForRowAt indexPath called")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        // Ternary Operator: Value = condition ? valueIfTrue : valueIfFalse
        
        return cell
    }
    
    
    // MARK: - Data Manipulation Methods
    // Save Data and Load Data

    
    func saveCategories(){
        
        do {
            try context.save()
        } catch {
            print("Error saving context : \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    // loadCategories() **********
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        // See notes at bottom
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    // MARK: - Add New Categories
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
                // See Notes at bottom
            
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
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
            
            destinationVC.selectedCategory = categoryArray[indexPath.row]
                // Need to create the property selectedVategory in the ToDoListCOntroller
        
        }
            // The indexPath that will indicate the current row that is selected
    }
    
}



/*

 let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    - A singleton App instance. At the timepoint when the app is running, the shared UIApplication will correspond to the live application object
    - Tap into UIApplication class --> getting the shared singelton object, which corresponds to the current app as an object --> Tap into its delegate which has the data type of an optional UIApplication delegate --> cast into our class AppDelegate because they both inherit from the same super class UIApplication delegate --> (Now we have access to our app delegate as an object) --> Now can tap into its property called persistentContainer --> Grab the viewContext of that persistent container

 let newCategory = Category(context: self.context)
    - let newItem = Item(context: NSManagedObjectContext)
    - context - context where this item is going to exist. The view context of our persistent container
 
 func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
    -  .. = Item.fetchRequest() will serve as a default value, incase no other request is put as a parameter
 */

