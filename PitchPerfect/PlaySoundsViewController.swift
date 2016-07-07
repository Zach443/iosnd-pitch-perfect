//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Zach Fiorito on 7/1/16.
//  Copyright © 2016 Zach Fiorito. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudio: NSURL!
    
    var recordedAudioURL: NSURL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: NSTimer!
    
    enum ButtonType: Int {case Vader = 0, Chipmunk}
    
    @IBAction func playSoundForButton(sender: UIButton) {
        
        switch(ButtonType(rawValue: sender.tag)!) {
        case .Vader:
            playSound(-1000)
        case .Chipmunk:
            playSound(2000)
        }
    }

    @IBAction func stopPlayingSound(sender: UIButton) {
        stopAudio()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        settupButtons(.NotPlaying)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
