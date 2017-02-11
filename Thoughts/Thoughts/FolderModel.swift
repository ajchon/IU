//
//  FolderModel.swift
//  Thoughts
//
//  Created by Adam Chon on 5/1/16.
//  Copyright © 2016 A290 Spring 2016 - ajchon. All rights reserved.

/* Thoughts
* Adam Chon (ajchon)
* Final Project
* A290 - iOS App Dev II - Spring 2016 - 2nd eight weeks
* 5/4/2016
*/

import UIKit
import CoreData

// Implement UITableViewDataSource protocol to mediate the app's data model for the UITableView:

class FolderModel: NSObject {

    // instance variable to store a reference to the app Delegate:
    var iAppDelegate: AppDelegate? = nil
    // instance variable to store a reference to the managed Object Context:
    var iManagedContext: NSManagedObjectContext? = nil
    // with Core Data, all data is stored in an NSManagedObject:
    var iFolders = [NSManagedObject]()
    
    //-----------------------------------------------------------------------------------------
    override init() {
        
        // now obtain a reference to the App Delegate...
        self.iAppDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        // ... from the App Delegate, get a reference to the Managed Object Context:
        self.iManagedContext = self.iAppDelegate?.managedObjectContext
        
        let lFolderFetchRequest = NSFetchRequest(entityName: "Folder")
        
        // finally obtain all entities representing Users from
        //   the Managed Object Context persistent storage:
        do {
            // obtain the array of objects that meet the criteria
            //   specified by request,
            //   fetched from the receiver,
            //   and from the persistent stores associated with the
            //   receiver’s persistent store coordinator:
            let lFolderArrayOfObjects = try self.iManagedContext!.executeFetchRequest(lFolderFetchRequest)
            
            // keep the obtained array of objects in an instance variable:
            self.iFolders = lFolderArrayOfObjects as! [NSManagedObject]
        } catch let lError as NSError {
            // if anything went wrong while trying to save, report the error:
            NSLog("Error in fetching \(lError), \(lError.userInfo)")
        }
    }
    
    //-----------------------------------------------------------------------------------------
    // create a Core Data entity for a new User,
    //   and save it to the Managed Object Context:
    func createNewFolderEntity(
        pFolderName: String,
        pDateCreated: String) {
            
            // prepare a description of a Core Data entity,
            //   as specified in our .xcdatamodeld file:
            let lEntityDescription =  NSEntityDescription.entityForName(
                "Folder",
                inManagedObjectContext:self.iManagedContext!)
            
            // create a managed object
            //   representing one User entity in our Core Data collection:
            let lFolder = NSManagedObject(
                entity: lEntityDescription!,
                insertIntoManagedObjectContext: self.iManagedContext)
            
            // set the key-value coding defined in our .xcdatamodeld file, i.e.
            //   assign:
            //     to the lFolder entity just created,
            //     at the "folderName" key,
            //     the value found in pFolderName
            lFolder.setValue(pFolderName, forKey: "folderName")
            
            lFolder.setValue(pDateCreated, forKey: "dateCreated")
            
            // finally save the new entity representing a new User
            //   into the Managed Object Context
            do {
                try self.iManagedContext!.save()
                // if the new entity saved correctly to the Managed Object Context,
                //   also add it to the instance variable, for displaying it in the table:
                self.iFolders.append(lFolder)
            } catch let lError as NSError  {
                // if anything went wrong while trying to save, report the error:
                NSLog("Error in saving \(lError), \(lError.userInfo)")
            }
    }

    
    //-----------------------------------------------------------------------------------------
    func fetchEntities(pEntityName: String) {
        // first prepare the type of fetch request, i.e.
        //   find all entities named "Folder":
        let lFetchRequest = NSFetchRequest(entityName: pEntityName)
        
        
        // finally obtain all entities representing Users from
        // the Managed Object Context persistent storage:
        do {
            // obtain the array of objects that meet the criteria
            //   specified by request, fetched from the receiver,
            //   and from the persistent stores associated with the
            //   receiver’s persistent store coordinator:
            let lFolderArrayOfObjects = try self.iManagedContext!.executeFetchRequest(lFetchRequest)
            // keep the obtained array of objects in an instance variable:
            self.iFolders = lFolderArrayOfObjects as! [NSManagedObject]
        } catch let lError as NSError {
            // if anything went wrong while trying to save, report the error:
            NSLog("Error in fetching \(lError), \(lError.userInfo)")
        }
    }
    
    
}
