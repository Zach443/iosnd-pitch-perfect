//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Zach Fiorito on 7/1/16.
//  Copyright © 2016 Zach Fiorito. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //I found this little fix on the forums that allows the
        //sound to play from the actual speaker of your device
        //as opposed to the ear speaker on the iPhones
        let session = AVAudioSession.sharedInstance()
        try! session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: AnyObject) {
        print("Record button pressed")
        recordingLabel.text = "Recording in Progress..."
        
        //Disable the recording button while recording
        recordButton.enabled = false
        
        //Create the file name for our audio; create variable for path to file
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "recordedConvo.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        //Create our AVAudio Session, and set it's category
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        //Set up the audioRecorder, and beign recording
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    @IBAction func stopRecording(sender: AnyObject) {
        print("Stop Recording Button Pressed")
        recordingLabel.text = "Tap to Record"
        
        //Enable correct buttons
        recordButton.enabled = true
        stopRecordingButton.enabled = false
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AVAudioRecorder finished recording audio clip")
        if (flag) {
            print("Audio clip successfully saved")
            self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        } else {
            print("Audio Clip has failed to save :(")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        stopRecordingButton.enabled = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudio = recordedAudioURL
        }
    }

}

