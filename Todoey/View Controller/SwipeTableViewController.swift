//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Mitsuharu Enatsu on 5/31/18.
//  Copyright © 2018 Mitsuharu Enatsu. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
            // Create a new cell, from the prototype "Cell" and is created as a SwipeTableViewCell
        
        cell.delegate = self
            // Retained as is because this class (SwipeTableViewController) is the one that will handle the swipe actions anyway
            // Set cell's delegate as the current class (SwipeTableViewController) to enable all of our delegate methods to work
        
        return cell
            // The cell that is returned is placed in the subclass calling it, like in let cell = super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else {
            return nil
        }
            // Orientation of swipe is from the right
            // Swipe from the right in selected cell, then trigger closure below.
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            print("Item deleted")
            self.updateModel(at: indexPath)
        }
             // Handle action by updating model with deletion
        
        deleteAction.image = UIImage(named: "delete-icon")
            // Add an image to the part of the cell that is going to show when user swipes
            // Delete-icon is the name of the asset
            // Customize the action appearance
        
        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
        // Method directly copied from github: "Optionally, you can implement the editActionsOptionsForRowAt method to customize the behavior of the swipe actions:"
    

    func updateModel(at indexPath: IndexPath) {
        // Update data model
        // Empty function to be overriden and implemented by subclass
        // Called in editActionsForRowAt function in this class. But the code of the updateModel that is called will be based on how the subclass overriding it will make its implementation
    }
    
}

