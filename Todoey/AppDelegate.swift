//
//  AppDelegate.swift
//  Todoey
//
//  Created by Mitsuharu Enatsu on 5/8/18.
//  Copyright © 2018 Mitsuharu Enatsu. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    // MARK - didFinishLaunching
    // Notes: Called when app gets launched. Happens before viewDidLoad()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        print("didFinishLaunching")
        
        return true
    }


    // MARK -   applicationWillTerminate
    // Notes:   Point where app will be terminated. Could be user triggered or system triggered. (Press home button, when you swipe the app up to terminate it). If your app is memory intensive, another app might reclaim the resources being used. then if could go from bieng in the background ot getting terminated.
    
    func applicationWillTerminate(_ application: UIApplication) {

        print("applicationWillTerminate")
        self.saveContext()
    }
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
  
        let container = NSPersistentContainer(name: "DataModel")
            // Create NSPersistentContainer using our core data "DataModel"
            // This is the DB we will be saving to
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
   
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
        // When this container is returned, we will be able to access the object in our classess and save or pull data as needed
    }()
    
    
    // MARK: - Core Data Saving support
    // Support when saving data when application gets terminated
    
    func saveContext () {
        let context = persistentContainer.viewContext
            // viewContext is an area where you can change and update your data so that you can undo and redo until you're happy with your data and save the data in uyour context (which is temporary), to the container (which is for permanent storage
            // Context is similar to the Staging area in GitHUb
        if context.hasChanges {
            do {
                try context.save()
                    // Once we are happy with the changes, we commit to permament storage
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
}



/*
 Application:
    application(... didFinishLaunching
 
 
 NSSearchPathForDirectoriesInDomains(<#T##directory: FileManager.SearchPathDirectory##FileManager.SearchPathDirectory#>, <#T##domainMask: FileManager.SearchPathDomainMask##FileManager.SearchPathDomainMask#>, <#T##expandTilde: Bool##Bool#>
 
 NSPersistentContainer
 (Where you will store all your data. By default this is an SQLite database)
 
 
 
 
 Deleted:
 
 
 // MARK -   applicationWillResignActive
 // Notes:   Triggered when something happens to Phone while in foreground. Ex, user receives a call, you can do something to prevent user from losing data (Ex. user filling out form in app, gets a call, won't lose data)
 
 func applicationWillResignActive(_ application: UIApplication) {
 
 }
 
 
 // MARK -   applicationDidEnterBackground
 // Notes:   Happens when app disappears off scree. (Press home button, open a different app)
 
 func applicationDidEnterBackground(_ application: UIApplication) {
 print("applicationDidEnterBackground")
 }
 
 
 // MARK - applicationWillEnterForeground
 
 func applicationWillEnterForeground(_ application: UIApplication) {
 // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
 }
 
 func applicationDidBecomeActive(_ application: UIApplication) {
 // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
 }
 
 */

