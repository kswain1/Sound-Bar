//
//  SoundListViewController.swift
//  Sound Bar
//
//  Created by kehlin swain on 12/19/14.
//  Copyright (c) 2014 Kehlin Swain. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class SoundListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var audioPlayer = AVAudioPlayer()
    
    var sounds: [Sound] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //the data for app is coming from this viewcontroller
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Let's Go
        
        var context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Sound")
        
        self.sounds = context.executeFetchRequest(request, error: nil) as [Sound]

        
    }

    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    //deleting a row in the table view
   func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
     var context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
          // delete the object inside of context data
            context.deleteObject(self.sounds[indexPath.row])
            self.viewWillAppear(Bool())
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sounds.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //going to pass where ever the person touches in the index of the row
        
        var sound = self.sounds[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? UITableViewCell
        if !(cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL")}
            
        cell!.textLabel.text = sound.name
        return cell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        //returns wherever the user has clicked on the row
        var sound = self.sounds[indexPath.row]
        
        //transformss the sound.url into a url value
        var baseString : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.UserDomainMask , true) [0] as String
        
        var PathComponents = [baseString, sound.url]
        var audioNSURL = NSURL.fileURLWithPathComponents(PathComponents)!

       //contentsOfUrl means where can i find the URL sound error presentation when error happens
        self.audioPlayer = AVAudioPlayer(contentsOfURL: audioNSURL , error: nil)
        self.audioPlayer.play()
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var nextViewController = segue.destinationViewController as NewSoundViewController
        nextViewController.previousViewController = self
    }

}

