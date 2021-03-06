//
//  AppDelegate.swift
//  Todoey
//
//  Created by Mitsuharu Enatsu on 5/8/18.
//  Copyright © 2018 Mitsuharu Enatsu. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    // MARK - didFinishLaunching
    // Notes: Called when app gets launched. Happens before viewDidLoad()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
            // Commented out just to remove warnings, but this can be useful later on if you want to get file location of the realm file
        
        do {
            _ = try Realm()
        } catch {
            print("Error initializing new Realm : \(error)")
        }
        
        return true
    }


    // MARK -   applicationWillTerminate
    // Notes:   Point where app will be terminated. Could be user triggered or system triggered. (Press home button, when you swipe the app up to terminate it). If your app is memory intensive, another app might reclaim the resources being used. then if could go from bieng in the background ot getting terminated.
    
    func applicationWillTerminate(_ application: UIApplication) {

        print("applicationWillTerminate")
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
 

 
 Realm
    .write
        Write the data to the persistent storage
    .add
        Add the specific object ot the persistent storage
    .Configuration.defaultConfiguration.fileURL
        Location of Realm file
 
 */

