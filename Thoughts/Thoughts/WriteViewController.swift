//
//  WriteViewController.swift
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

class WriteViewController: UIViewController {
    
    // Instance variable to store a reference to:
    // - app delegate
    var iAppDelegate: AppDelegate? = nil
    // - managed object context
    //var iManagedContext: NSManagedObjectContext? = nil
    // - model class
    var iModel: ThoughtsModel? = nil
    var iFileVC: FileViewController? = nil
    
    @IBAction func addFile(sender: AnyObject) {
        
        // new users data is input from an UIAlertController:
        let lAlert = UIAlertController(
            title: "New Note",
            message: "Please enter new note title",
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
                // get text input from file:
                let inputTextFromFile = lAlert.textFields!.first
                // save fileName for new file:
                self.iModel!.createNewFileEntity(inputTextFromFile!.text!)
                // ask the table to redisplay its content:
                self.iFileVC!.iTableView.reloadData()
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

}
    /*
    // the reference to our AppDelegate:
    var appDelegate: AppDelegate?
    var convertModel: ConvertModel?
    
    
    @IBOutlet var dollarLabel:UILabel!          // indicates dollar amount entered
    @IBOutlet var textEntry : UITextField!      // test field
    @IBOutlet var pesosLabel:UILabel!           // shows pesos conversion
    @IBOutlet var textViewOutput : UITextView!   // returns last conversion
    
    let which = 1
    
    @IBAction func convertMoney(sender: AnyObject) {
        var answer: Double = 0.0
        let field = textEntry.text
        
        if let num = Double(field!) {
            answer = num * convertModel!.pesos
        }
        self.pesosLabel.text = " Pesos: \(answer)"
        
        // saves content
        let fm = NSFileManager()
        var err : NSError?
        let myDocumentsDirectoryURL = try! fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        if let num = Double(field!) {
            let aHistory = History(dollarX: num, foreignX: answer)
            
            let aHistoryArchivedData = NSKeyedArchiver.archivedDataWithRootObject(aHistory)
            let myDataFileURL = myDocumentsDirectoryURL.URLByAppendingPathComponent("archivedDataFile.binary")
            switch which {
            case 1:
                aHistoryArchivedData.writeToURL(myDataFileURL, atomically: true)
                // myDataFileURL.setResourceValue(true, forKey: NSURLIsExcludedFromBackupKey, error: &err)
            case 2:
                // ==== the NSFileCoordinator way
                let fc = NSFileCoordinator()
                let intent = NSFileAccessIntent.writingIntentWithURL(myDataFileURL, options: [])
                fc.coordinateAccessWithIntents([intent], queue: NSOperationQueue.mainQueue()) {
                    (err:NSError?) in
                    // compiler gets confused if a one-liner returns a BOOL result
                    let ok = aHistoryArchivedData.writeToURL(intent.URL, atomically: true)
                }
            default:break
            }
        }
    }
    
    // retrieve last conversion
    @IBAction func retrieveConversionData (sender:AnyObject!) {
        let fm = NSFileManager()
        var err : NSError?
        let myDocumentsDirectoryURL = try! fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        let myDataFileURL = myDocumentsDirectoryURL.URLByAppendingPathComponent("archivedDataFile.binary")
        
        // warning! here do error testing to prevent
        //   the app crashing if you try reading from a file that does not exist!
        
        switch which {
        case 1:
            let historydata = NSData(contentsOfURL: myDataFileURL)!
            let history = NSKeyedUnarchiver.unarchiveObjectWithData(historydata) as! History
            print(history)
            textViewOutput.text = textViewOutput.text + "\(history)\n" + "--------\n"
        case 2:
            // ==== the NSFileCoordinator way
            let fc = NSFileCoordinator()
            let intent = NSFileAccessIntent.readingIntentWithURL(myDataFileURL, options: [])
            fc.coordinateAccessWithIntents([intent], queue: NSOperationQueue.mainQueue()) {
                (err:NSError?) in
                let historydata = NSData(contentsOfURL: intent.URL)!
                let history = NSKeyedUnarchiver.unarchiveObjectWithData(historydata) as! History
                print(history)
                self.textViewOutput.text = self.textViewOutput.text + "\(history)\n" + "--------\n"
            }
        default:break
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // implement convert model function
        convertModel = ConvertModel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

*/






