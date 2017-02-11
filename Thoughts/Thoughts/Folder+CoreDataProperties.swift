//
//  Folder+CoreDataProperties.swift
//  Thoughts
//
//  Created by Adam Chon on 5/2/16.
//  Copyright © 2016 A290 Spring 2016 - ajchon. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.

/* Thoughts
* Adam Chon (ajchon)
* Final Project
* A290 - iOS App Dev II - Spring 2016 - 2nd eight weeks
* 5/4/2016
*/

import Foundation
import CoreData

extension Folder {

    @NSManaged var dateCreated: String?
    @NSManaged var folderName: String?
    @NSManaged var theFiles: NSData?
    @NSManaged var saveFile: NSSet?

}
