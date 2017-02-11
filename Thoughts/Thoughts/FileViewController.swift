//
//  FileViewController.swift
//  Thoughts
//
//  Created by Adam Chon on 4/27/16.
//  Copyright © 2016 A290 Spring 2016 - ajchon. All rights reserved.

/* Thoughts
 * Adam Chon (ajchon)
 * Final Project
 * A290 - iOS App Dev II - Spring 2016 - 2nd eight weeks
 * 5/4/2016
 */

import UIKit
import CoreData


class FileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    // the table view that this ViewController controls:
    @IBOutlet weak var iTableView: UITableView!
    //@IBOutlet var folderTitle: UINavigationItem!
    //@IBOutlet weak var iView: UIView!
    
    
    // instance variable to store a reference to:
    // - app delegate
    var iAppDelegate: AppDelegate? = nil
    // - managed object context
    var iManagedContext: NSManagedObjectContext? = nil
    // - model class
    var iModel: ThoughtsModel? = nil
    // var iFileModel: FileModel?
    var fName = String()
    
    //---------------------------------------------------------------------------------------------------
    @IBAction func addFile(sender: AnyObject) {
        
        // new users data is input from an UIAlertController:
        let myAlert = UIAlertController(
            title: "New File",
            message: "Please enter new file name",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        // alert controller may end with "Cancel" or "Save"
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.Default,
            handler: {
                (action: UIAlertAction) -> Void in
                // do nothing if "Cancel" is pressed
            }
        )
        
        let saveAction = UIAlertAction(
            title: "Save",
            style: UIAlertActionStyle.Default,
            handler: {
                (action: UIAlertAction) -> Void in
                // get text input from file:
                let inputTextFromFile = myAlert.textFields!.first
                // save filename for new file:
                self.iModel!.createNewFileEntity(inputTextFromFile!.text!)
                // ask the table to redisplay its content:
                self.iTableView.reloadData()
            }
        )
        
        // add 2 actions as buttons to alert controller:
        myAlert.addAction(cancelAction)
        myAlert.addAction(saveAction)
        
        // also need input text field:
        myAlert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
            // configure input test field - nothing to do
        }
        
        // present alert to user:
        presentViewController(
            myAlert,
            animated: true,
            completion: nil)
    }

    //---------------------------------------------------------------------------------------------------
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.iModel!.iFiles.count
    }
    
    //---------------------------------------------------------------------------------------------------
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // create a single cell for the table, displaying a file name:
        let myCell = self.iTableView.dequeueReusableCellWithIdentifier("FileCell")
        // obtain file name by querying one element in myFiles NSManagedObject...
        let thisFile = self.iModel!.iFiles[indexPath.row]
        // ... using the key-value coding defined in the .xcdatamodel file:
        myCell!.textLabel!.text = thisFile.valueForKey("fileName") as? String
        // myCell!.detailTextLabel!.text = thisFile.valueForKey("dateCreated") as? String
        // return the cell we just created:
        return myCell!
    }
    
    //---------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = self.iModel?.folderTitle
        // creating new table cells for the tableView table:
        self.iTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "FileCell")
        // obtain a reference to the App Delegate...
        iAppDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        // ..and a reference to our app's main model instance:
        self.iModel = self.iAppDelegate?.iModel
        // ask the model to obtain all entities representing Files:
        self.iModel!.fetchFileEntities("File")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = self.iModel?.folderTitle
    }
    
    //---------------------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
