//
//  FolderViewController.swift
//  Thoughts
//
//  Created by Adam Chon on 4/7/16.
//  Copyright © 2016 A290 Spring 2016 - ajchon. All rights reserved.

/* Thoughts
 * Adam Chon (ajchon)
 * Final Project
 * A290 - iOS App Dev II - Spring 2016 - 2nd eight weeks
 * 5/4/2016
 */

import UIKit
import CoreData

// note about variable/property naming convention in this file:
// variable names with an "i" prefix indicate instance variables or properties
// variable names with an "l" prefix indicate variables that are local to a method or function
// variable names with a "g" prefix indicate global variables

class FolderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    
    @IBOutlet weak var iTableView: UITableView!
    
    // Instance variable to store a reference to:
    // - app delegate
    var iAppDelegate: AppDelegate? = nil
    // - managed object context
    var iManagedContext: NSManagedObjectContext? = nil
    // - model class
    var iModel: ThoughtsModel? = nil
    
    // var tasks: Array<AnyObject> = []
    // self.navigationItem.leftBarButtonItem = self.editButtonItem()
    // @IBAction func iEdit(sender: UIBarButtonItem) {       }
    
    
    //---------------------------------------------------------------------------------------------------
    @IBAction func addFolder(sender: AnyObject) {
        
        // new users data is input from an UIAlertController:
        let lAlert = UIAlertController(
            title: "New Folder",
            message: "Please enter new folder name",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        // alert controller may end with "Cancel" or "Save"
        let lCancelAction = UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.Default,
            handler: {
                (action: UIAlertAction) -> Void in
                // do nothing if "Cancel" is pressed
            }
        )
    
        let lSaveAction = UIAlertAction(
            title: "Save",
            style: UIAlertActionStyle.Default,
            handler: {
                (action: UIAlertAction) -> Void in
                // get text input from folder:
                let inputTextFromFolder = lAlert.textFields!.first
                // save folderName for new folder:
                self.iModel!.createNewFolderEntity(inputTextFromFolder!.text!)
                // ask the table to redisplay its content:
                self.iTableView.reloadData()
            }
        )
        
        // add 2 actions as buttons to alert controller:
        lAlert.addAction(lCancelAction)
        lAlert.addAction(lSaveAction)
        
        // also need 1 input text field:
        lAlert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
            // configure input test field - nothing to do
        }
        
        // present alert to user:
        presentViewController(
            lAlert,
            animated: true,
            completion: nil
        )
    }
    
    
    //---------------------------------------------------------------------------------------------------
    // UITableViewDataSource protocol methods:
    //---------------------------------------------------------------------------------------------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.iModel!.iFolders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // create a single cell for the table, displaying a file name:
        let lCell = self.iTableView.dequeueReusableCellWithIdentifier("FolderCell")
        // obtain file name by querying one element in myFolders NSManagedObject...
        let lFolder = self.iModel!.iFolders[indexPath.row]
        // ...using the key-value coding defined in the .xcdatamodel file:
        lCell!.textLabel!.text = lFolder.valueForKey("folderName") as? String
        // return the cell we just created:
        return lCell!
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // get shared instance of app delegate and moc
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let moc = appDelegate.managedObjectContext
            // delete folderName and then save
            moc.deleteObject(self.iModel!.iFolders[indexPath.row])
            appDelegate.saveContext()
            // remove folderName from iFolders array so it doesn't appear anymore
            self.iModel!.iFolders.removeAtIndex(indexPath.row)
            self.iTableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // de-select row for clean animation
        let lFolder = self.iModel!.iFolders[indexPath.row]
        self.iModel?.folderTitle = lFolder.valueForKey("folderName") as! String
        self.iTableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("inFolder", sender: NSIndexPath.self)
    }

    //---------------------------------------------------------------------------------------------------
    // UIViewController class methods:
    //---------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // creating new table cells for the tableView table:
        self.iTableView.registerClass(
            UITableViewCell.self,
            forCellReuseIdentifier: "FolderCell")
        // obtain a reference to the App Delegate...
        self.iAppDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        // ..and a reference to our app's main model instance:
        self.iModel = self.iAppDelegate?.iModel
        // ask the model to obtain all entities that represent Folders:
        self.iModel!.fetchFolderEntities("Folder")
        
        iTableView.delegate = self
        iTableView.dataSource = self
    }
    
    //---------------------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //---------------------------------------------------------------------------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "inFolder" {
            //let Ftitle = self.iModel?.folderTitle
            //let dest: FileViewController = segue.destinationViewController as! FileViewController
            //let indPath = self.iTableView.indexPathForSelectedRow
            //let thisTask = fetchedResultsController.objectAtIndexPath(i!) as! ThoughtsModel
            //dest.folderTitle = Ftitle
        }
    }
    
    //---------------------------------------------------------------------------------------------------
    var fetchedResultsController: NSFetchedResultsController!
    
    func initFethcedResultsController() {
        let request = NSFetchRequest(entityName: "Folder")
        let fNameSort = NSSortDescriptor(key: "folderName", ascending: true)
        // let dateSort = NSSortDescriptor(key: "dateCreated", ascending: true)
        request.sortDescriptors = [fNameSort]
        
        let moc = self.iManagedContext
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: moc!,
            sectionNameKeyPath: "folderName",
            cacheName: "rootCache")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
}





    //---------------------------------------------------------------------------------------------------
    /*
    let CellSegueID = "inFolder"
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case CellSegueID:
            let destination = segue.destinationViewController as! FileViewController
            let indexPath = iTableView.indexPathForSelectedRow!
            let selectedObj = fetchedResultsController.objectAtIndexPath(indexPath) as! UITableView
            destination.iTableView = selectedObj
        default:
            print("Unknown segue: \(segue.identifier)")
        }
    }
*/
    
        //if segue.identifier == CellSegueID {
            //let fileVC: FileViewController = segue.destinationViewController as! FileViewController
            //let selectedItem: NSManagedObject = tasks[self.iTableView.indexPathForSelectedRow!.row] as! NSManagedObject
            //fileVC.fName = selectedItem.valueForKey("fileName") as! String
        //}

/*
//---------------------------------------------------------------------------------------------------
override func viewWillAppear(animated: Bool) {
    do {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let fetchreq = NSFetchRequest(entityName: "folderName")
        try tasks = context.executeFetchRequest(fetchreq)
        iTableView.reloadData()
    } catch let lError as NSError {
        NSLog("Error in saving \(lError), \(lError.userInfo)")
    }
} 
*/
/*
-- REORDER ROWS in tableView
override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
return .None
}
override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
return false
} 
*/

