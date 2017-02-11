//
//  CameraViewController.swift
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
import AVFoundation
import AVKit
import CoreMedia


class CameraViewController: UIViewController {
    
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
            title: "New File",
            message: "Please enter new file name",
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
                self.iModel!.createNewFolderEntity(inputTextFromFile!.text!)
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
    

    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    // if we find a device, store it here for later use
    var captureDevice : AVCaptureDevice?
    
    //---------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup after loading view
        captureSession.sessionPreset = AVCaptureSessionPresetLow
        
        let devices = AVCaptureDevice.devices()
        // print(devices)    <- return # of microphones and cameras (front/back)
        
        // loop through alll the capture devices on this phone
        for device in devices {
            // make sure phone supports video
            if(device.hasMediaType(AVMediaTypeVideo)) {
                // finally check position and confirm it is back camera
                if(device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        print("Capture device found")
                        beginSession()
                    }
                }
            }
        }
    }
    
    //---------------------------------------------------------------------------------------------------
    func focusTo(value : Float) {
        if let device = captureDevice {
            do {
                try device.lockForConfiguration()
            } catch {
                // handle error
                return
            }
            
            device.setFocusModeLockedWithLensPosition(value, completionHandler: {(time) -> Void in  })
            device.unlockForConfiguration()
        }
    }
    
    //---------------------------------------------------------------------------------------------------
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let anyTouch = touches.first as UITouch!
        let touchPercent = anyTouch!.locationInView(self.view).x / screenWidth
        focusTo(Float(touchPercent))
        
        // super.touchesBegan(touches, withEvent:event)
    }
    
    //---------------------------------------------------------------------------------------------------
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let anyTouch = touches.first as UITouch!
        let touchPercent = anyTouch!.locationInView(self.view).x / self.screenWidth
        focusTo(Float(touchPercent))
        
        // super.touchesBegan(touches, withEvent:event)
    }
    
    //---------------------------------------------------------------------------------------------------
    func configureDevice() {
        if let device = captureDevice {
            do {
                try device.lockForConfiguration()
            } catch {
                // handle error
                return
            }
            device.focusMode = .Locked
            device.unlockForConfiguration()
        }
    }
    
    //---------------------------------------------------------------------------------------------------
    // start capturing frames
    func beginSession() {
        
        // create AVCapture session
        // let err : NSError? = nil
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice) as AVCaptureInput
            // use deviceInput
            captureSession.addInput(deviceInput)
        } catch {
            print(error)
        }
        /*
        else {
            print("error: \(err?.localizedDescription)")
        } */
        
        // captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        
        previewLayer!.frame = self.view.bounds
        // self.view.layer.addSublayer(previewLayer)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer!)
        previewLayer?.frame = self.view.layer.frame
        captureSession.startRunning()
    }
    
    
    //---------------------------------------------------------------------------------------------------
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    //---------------------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

    
    
    /*
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<()>) {
        if keyPath == "readyForDisplay" {
            dispatch_async(dispatch_get_main_queue(), {
                self.finishConstructingInterface()
            })
        }
    }
    
    func finishConstructingInterface () {
        if (!self.playerLayer.readyForDisplay) {
            return
        }
        
        self.playerLayer.removeObserver(self, forKeyPath:"readyForDisplay")
        
        if self.playerLayer.superlayer == nil {
            self.view.layer.addSublayer(self.playerLayer)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: [])
        _ = try? AVAudioSession.sharedInstance().setActive(true, withOptions: [])
    }
    
    
    @IBAction func doButton (sender:AnyObject!) {
        let rate = self.player.rate
        if rate < 0.01 {
            self.player.rate = 1
        } else {
            self.player.rate = 0
        }
    }
    
    
    @IBAction func restart (sender:AnyObject!) {
        let item = self.player.currentItem! //
        item.seekToTime(CMTimeMake(0, 1))
    }
    
    @IBAction func doPicInPic(sender: AnyObject) {
        if self.pic.pictureInPicturePossible {
            self.pic.startPictureInPicture()
        }
    }

    */
    