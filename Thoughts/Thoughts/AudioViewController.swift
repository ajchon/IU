//
//  AudioViewController.swift
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

class AudioViewController: UIViewController,
    
    // The delegate of an AVAudioPlayer object must adopt the AVAudioPlayerDelegate protocol.
    // All of the methods in this protocol are optional.
    // They allow a delegate to respond to audio interruptions and audio decoding errors,
    // and to the completion of a sound’s playback.
    AVAudioPlayerDelegate,  // we're going to playback audio
    
    // The delegate of an AVAudioRecorder object must adopt the AVAudioRecorderDelegate protocol.
    // All of the methods in this protocol are optional.
    // They allow a delegate to respond to audio interruptions and audio decoding errors,
    // and to the completion of a recording.
    
    AVAudioRecorderDelegate // we're going to record audio
    
{
    // instance variables:
    var iAudioRecorder: AVAudioRecorder?
    var iAudioPlayer: AVAudioPlayer?
    var iFileVC: FileViewController? = nil
    var iModel: ThoughtsModel? = nil
    
    
    // ----------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // ----------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // ----------------------------------------------------------------------
    @IBAction func myRecordAndPlaybackButton(sender: AnyObject) {
        
        /* Ask for permission to see if we can record audio */
        
        var error: NSError?
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(
                AVAudioSessionCategoryPlayAndRecord,
                withOptions: .DuckOthers)
            
            do {
                try session.setActive(true)
                NSLog("AudioTab: Successfully activated the audio session")
                
                session.requestRecordPermission{[weak self](allowed: Bool) in
                    
                    if allowed{
                        self!.startRecordingAudio()
                    } else {
                        NSLog("AudioTab: We don't have permission to record audio");
                    }
                    
                }
            } catch _ {
                NSLog("AudioTab: Could not activate the audio session")
            }
            
        } catch let error1 as NSError {
            error = error1
            
            if let theError = error {
                NSLog("AudioTab: An error occurred in setting the audio " +
                    "session category. Error = \(theError)")
            }
            
        }
        
        
    }
    
    
    // ----------------------------------------------------------------------
    func startRecordingAudio(){
        
        var settingRecorderError: NSError?
        
        let audioRecordingURL = self.audioRecordingPath()
        
        do {
            iAudioRecorder = try AVAudioRecorder(URL: audioRecordingURL,
                settings: audioRecordingSettings() as! [String : AnyObject])
        } catch let error1 as NSError {
            settingRecorderError = error1
            iAudioRecorder = nil
            NSLog("AudioTab: error in setting audio recording: \(settingRecorderError)")
        }
        
        if let recorder = iAudioRecorder{
            
            recorder.delegate = self
            /* Prepare the recorder and then start the recording */
            
            if recorder.prepareToRecord() && recorder.record(){
                
                NSLog("AudioTab: Successfully started to record.")
                
                /* After 5 seconds, let's stop the recording process */
                let delayInSeconds = 5.0
                let delayInNanoSeconds =
                dispatch_time(DISPATCH_TIME_NOW,
                    Int64(delayInSeconds * Double(NSEC_PER_SEC)))
                
                dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), {
                    [weak self] in
                    self!.iAudioRecorder!.stop()
                    })
                
            } else {
                NSLog("AudioTab: Failed to record.")
                iAudioRecorder = nil
            }
            
        } else {
            NSLog("AudioTab: Failed to create an instance of the audio recorder")
        }
        
    }
    
    
    // ----------------------------------------------------------------------
    func audioRecordingPath() -> NSURL{
        
        let fileManager = NSFileManager()
        
        let documentsFolderUrl = try? fileManager.URLForDirectory(.DocumentDirectory,
            inDomain: .UserDomainMask,
            appropriateForURL: nil,
            create: false)
        
        return documentsFolderUrl!.URLByAppendingPathComponent("Recording.m4a")
        
    }
    
    
    // ----------------------------------------------------------------------
    func audioRecordingSettings() -> NSDictionary {
        
        /* Let's prepare the audio recorder options in the dictionary.
        Later we will use this dictionary to instantiate an audio
        recorder of type AVAudioRecorder */
        
        return [
            AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey : 16000.0,
            AVNumberOfChannelsKey : NSNumber(float: 1),
            AVEncoderAudioQualityKey : AVAudioQuality.High.rawValue
        ]
        
    }
    
    
    
    // ----------------------------------------------------------------------
    // MARK: AVAudioPlayerDelegate protocol
    // ----------------------------------------------------------------------
    
    
    // ----------------------------------------------------------------------
    //  delegate method for Responding to Sound Playback Completion
    //  audioPlayerDidFinishPlaying(_:successfully:)
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer,
        successfully flag: Bool){
            
            if flag{
                NSLog("AudioTab: Audio player stopped correctly")
            } else {
                NSLog("AudioTab: Audio player did not stop correctly")
            }
            
            iAudioPlayer = nil
            
    }
    
    // ----------------------------------------------------------------------
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        // we should properly respond to any error that may occur during playback
        NSLog("AudioTab: audioPlayerDecodeErrorDidOccur !!!")
    }
    
    
    // ----------------------------------------------------------------------
    // deprecated as of iOS 8.0
    // ----------------------------------------------------------------------
    func audioPlayerBeginInterruption(player: AVAudioPlayer) {
        /* The audio session is deactivated here */
    }
    
    // ----------------------------------------------------------------------
    // deprecated as of iOS 8.0
    // ----------------------------------------------------------------------
    func audioPlayerEndInterruption(player: AVAudioPlayer,
        withOptions flags: Int) {
            if flags == AVAudioSessionInterruptionFlags_ShouldResume{
                player.play()
            }
    }
    
    
    // ----------------------------------------------------------------------
    // MARK: AVAudioRecorderDelegate protocol
    // ----------------------------------------------------------------------
    
    
    
    // ----------------------------------------------------------------------
    // Called by the system when a recording is stopped
    //   or has finished due to reaching its time limit.
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder,
        successfully flag: Bool){
            
            if flag {
                
                NSLog("AudioTab: Successfully stopped the audio recording process")
                
                /* Let's try to retrieve the data for the recorded file */
                var playbackError:NSError?
                var readingError:NSError?
                
                let fileData: NSData?
                do {
                    fileData = try NSData(contentsOfURL: audioRecordingPath(), options: .MappedRead)
                } catch let error as NSError {
                    readingError = error
                    fileData = nil
                    NSLog("AudioTab: error in reading file: \(readingError)")
                }
                
                do {
                    /* Form an audio player and make it play the recorded data */
                    iAudioPlayer = try AVAudioPlayer(data: fileData!)
                } catch let error as NSError {
                    playbackError = error
                    iAudioPlayer = nil
                    NSLog("AudioTab: error in audio playback: \(playbackError)")
                }
                
                /* Could we instantiate the audio player? */
                if let player = iAudioPlayer{
                    player.delegate = self
                    
                    /* Prepare to play and start playing */
                    if player.prepareToPlay() && player.play(){
                        NSLog("AudioTab: Started playing the recorded audio")
                    } else {
                        NSLog("AudioTab: Could not play the audio")
                    }
                    
                } else {
                    NSLog("AudioTab: Failed to create an audio player")
                }
                
            } else {
                NSLog("AudioTab: Stopping the audio recording failed")
            }
            
            /* Here we don't need the audio recorder anymore */
            self.iAudioRecorder = nil;
    } // end of audioRecorderDidFinishRecording()
    
    
    @IBAction func addFile(sender: AnyObject) {
        
        // new users data is input from an UIAlertController:
        let lAlert = UIAlertController(
            title: "New File",
            message: "Please enter new file title",
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