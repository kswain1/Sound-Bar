//
//  NewSoundViewController.swift
//  Sound Bar
//
//  Created by kehlin swain on 12/19/14.
//  Copyright (c) 2014 Kehlin Swain. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData


class NewSoundViewController: UIViewController {

    required init(coder aDecoder: NSCoder) {
        var baseString : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.UserDomainMask , true) [0] as! String
        
        self.audioURL = NSUUID().UUIDString + ".m4a"
        var PathComponents = [baseString, self.audioURL]
        var audioNSURL = NSURL.fileURLWithPathComponents(PathComponents)!
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        var recordSettings: [NSObject : AnyObject] = Dictionary()
        recordSettings[AVFormatIDKey] = kAudioFormatMPEG4AAC
        recordSettings[AVSampleRateKey] = 44100.0
        recordSettings[AVNumberOfChannelsKey] = 2
        
        self.audioRecorder = AVAudioRecorder(URL: audioNSURL, settings: recordSettings, error: nil)
        self.audioRecorder.meteringEnabled = true
        self.audioRecorder.prepareToRecord()
        
        //super init is below
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var addSoundTextField: UITextField!
    
    //Want the button to change its appearance once clicked
    @IBOutlet weak var recordButton: UIButton!
    
    
    @IBOutlet weak var RecordActivityIndicator: UIActivityIndicatorView!
    
    var audioRecorder: AVAudioRecorder
    
    var audioURL: String
    
    //way of referencing the soundlistviewcontroller to add information to it
    var previousViewController = SoundListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Let's Go!
        
        RecordActivityIndicator.hidesWhenStopped = true

        
        
    }
    //function happens when ever save buton is clicked
    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func saveTapped(sender: AnyObject) {
        
        //save sound to CoreData
        var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
       
        //create Sound Object
        
        //Sound() = empty sound obj.
        var sound = NSEntityDescription.insertNewObjectForEntityForName("Sound", inManagedObjectContext: context) as! Sound
        
        sound.name = self.addSoundTextField.text
        sound.url = self.audioURL
        
        //save to CoreData
        context.save(nil)
        
        
    
        //Dismiss the ViewController
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
    //the action of the button once clicked record
    @IBAction func recordTapped(sender: AnyObject) {
        
        RecordActivityIndicator.hidesWhenStopped = true
        
        if self.audioRecorder.recording{
            //stops recording
            //Record activity indicator
            RecordActivityIndicator.stopAnimating()
            RecordActivityIndicator.hidesWhenStopped = true
             self.audioRecorder.stop()
             self.recordButton.setTitle(" 👉 RECORD 👈 ", forState: UIControlState.Normal)
            
        } else {
            //starts the recoding
            var session = AVAudioSession.sharedInstance()
            
            session.setActive(true, error: nil)
            
            self.audioRecorder.record()
            
            self.recordButton.setTitle("✋ Stop Recording ✋", forState: UIControlState.Normal)
            RecordActivityIndicator.startAnimating()
            
        }
    
      
    }
}


