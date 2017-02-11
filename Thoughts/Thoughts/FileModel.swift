//
//  FileModel.swift
//  Thoughts
//
//  Created by Adam Chon on 5/2/16.
//  Copyright © 2016 A290 Spring 2016 - ajchon. All rights reserved.

/* Thoughts
* Adam Chon (ajchon)
* Final Project
* A290 - iOS App Dev II - Spring 2016 - 2nd eight weeks
* 5/4/2016
*/

import UIKit
import CoreData

class FileModel: NSObject {

    // instance variable to store a reference to the app Delegate:
    var iAppDelegate: AppDelegate? = nil
    // instance variable to store a reference to the managed Object Context:
    var iManagedContext: NSManagedObjectContext? = nil
    // with Core Data, all data is stored in an NSManagedObject:
    var iFiles = [NSManagedObject]()
    
    //-----------------------------------------------------------------------------------------
    override init() {
        
        // now obtain a reference to the App Delegate...
        self.iAppDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        // ... from the App Delegate, get a reference to the Managed Object Context:
        self.iManagedContext = self.iAppDelegate?.managedObjectContext
        
        let lFileFetchRequest = NSFetchRequest(entityName: "File")
        
        // finally obtain all entities representing Users from
        //   the Managed Object Context persistent storage:
        do {
            // obtain the array of objects that meet the criteria
            //   specified by request,
            //   fetched from the receiver,
            //   and from the persistent stores associated with the
            //   receiver’s persistent store coordinator:
            let lFileArrayOfObjects = try self.iManagedContext!.executeFetchRequest(lFileFetchRequest)
            // keep the obtained array of objects in an instance variable:
            self.iFiles = lFileArrayOfObjects as! [NSManagedObject]
        } catch let lError as NSError {
            // if anything went wrong while trying to save, report the error:
            NSLog("Error in fetching \(lError), \(lError.userInfo)")
        }
    }
    
    //-----------------------------------------------------------------------------------------
    func createNewFileEntity(
        pFileName: String,
        pDateCreated: String) {
            
            // prepare a description of a Core Data entity,
            //   as specified in our .xcdatamodeld file:
            let lEntityDescription =  NSEntityDescription.entityForName("File",
                inManagedObjectContext:self.iManagedContext!)
            
            // create a managed object
            //   representing one User entity in our Core Data collection:
            let lFile = NSManagedObject(entity: lEntityDescription!,
                insertIntoManagedObjectContext: self.iManagedContext)
            
            // set the key-value coding defined in our .xcdatamodeld file, i.e.
            //   assign:
            //     to the lFolder entity just created,
            //     at the "folderName" key,
            //     the value found in pFileName
            lFile.setValue(pFileName, forKey: "fileName")
            
            lFile.setValue(pDateCreated, forKey: "dateCreated")
            
            // finally save the new entity representing a new User
            //   into the Managed Object Context
            do {
                try self.iManagedContext!.save()
                // if the new entity saved correctly to the Managed Object Context,
                //   also add it to the instance variable, for displaying it in the table:
                self.iFiles.append(lFile)
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
            let fileArrayOfObjects = try self.iManagedContext!.executeFetchRequest(lFetchRequest)
            // keep the obtained array of objects in an instance variable:
            self.iFiles = fileArrayOfObjects as! [NSManagedObject]
        } catch let lError as NSError {
            // if anything went wrong while trying to save, report the error:
            NSLog("Error in fetching \(lError), \(lError.userInfo)")
        }
    }
    
}
