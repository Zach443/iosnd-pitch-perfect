//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Zach Fiorito on 7/1/16.
//  Copyright © 2016 Zach Fiorito. All rights reserved.
//

import UIKit

class RecordSoundsViewController: UIViewController {

    @IBOutlet weak var recordingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordButtonPressed(sender: AnyObject) {
        print("Record button pressed")
        recordingLabel.text = "Recording in Progress..."
    }
    
    
    @IBAction func stopButtonPressed(sender: AnyObject) {
        print("Stop Recording Button Pressed")
        recordingLabel.text = "Tap to Record"
    }

}

