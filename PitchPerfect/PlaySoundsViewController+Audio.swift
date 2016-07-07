//
//  PlaySoundsViewController+Audio.swift
//  PitchPerfect
//
//  Copyright © 2016 Udacity. All rights reserved.
//
import UIKit
import AVFoundation

extension PlaySoundsViewController: AVAudioPlayerDelegate {
    //MARK: Alert Strings
    struct Alerts {
        static let DismissAlert = "Dismiss"
        static let RecordingDisabledTitle = "Recording Disabled"
        static let RecordingDisabledMessage = "You've disabled this app from recording your microphone. Check Settings."
        static let RecordingFailedTitle = "Recording Failed"
        static let RecordingFailedMessage = "Something went wrong with your recording."
        static let AudioRecorderError = "Audio Recorder Error"
        static let AudioSessionError = "Audio Session Error"
        static let AudioRecordingError = "Audio Recording Error"
        static let AudioFileError = "Audio File Error"
        static let AudioEngineError = "Audio Engine Error"
    }
    
    enum PlayingState { case Playing, NotPlaying }

    //Mark for easy navigation
    // MARK: Audio Functions
    
    func setupAudio() {
        // initialize recorded audio file
        do {
            audioFile = try AVAudioFile(forReading: recordedAudioURL)
        } catch {
            showAlert(Alerts.AudioFileError, message: String(error))
        }
        print("Audio has been setup")
    }
    //Cut down this function as only pitch is modified in this project
    func playSound(pitch: Float? = nil) {
        
        // initialize audio engine components
        audioEngine = AVAudioEngine()
        
        // node for playing audio
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // node for adjusting rate/pitch
        let adjustPitchNode = AVAudioUnitTimePitch()
        if let pitch = pitch {
            adjustPitchNode.pitch = pitch
        }
        
        //Didn't use the connectAudioNodes method from example because it was an unnecessary due to
        //there only being two nodes required in this project
        audioEngine.attachNode(adjustPitchNode)
        audioEngine.connect(audioPlayerNode, to: adjustPitchNode, format: audioFile.processingFormat)
        
        //Schedule our audio to begin
        audioPlayerNode.stop()
        audioPlayerNode.scheduleFile(audioFile, atTime: nil) {
            
            var delayInSeconds: Double = 0
            
            if let lastRenderTime = self.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayerNode.playerTimeForNodeTime(lastRenderTime) {
                
                delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate)

            }
            
            // schedule a stop timer for when audio finishes playing
            self.stopTimer = NSTimer(timeInterval: delayInSeconds, target: self, selector: #selector(PlaySoundsViewController.stopAudio), userInfo: nil, repeats: false)
            NSRunLoop.mainRunLoop().addTimer(self.stopTimer!, forMode: NSDefaultRunLoopMode)
        }
        
        do {
            try audioEngine.start()
        } catch {
            showAlert(Alerts.AudioEngineError, message: String(error))
            return
        }
        
        // play the recording!
        audioPlayerNode.play()
    }
    
    func stopAudio() {
        
        if let stopTimer = stopTimer {
            stopTimer.invalidate()
        }
        
        settupButtons(.NotPlaying)
        
        if let audioPlayerNode = audioPlayerNode {
            audioPlayerNode.stop()
        }
        
        if let audioEngine = audioEngine {
            audioEngine.stop()
            audioEngine.reset()
        }
    }
    
    
    // MARK: UI Functions
    
    /**My own version of the configureUI() function provided in the example
       For better or worse, I just wanted to create my own instead of
       copy/pasting all the example code **/
    func settupButtons(playState: PlayingState) {
        switch(playState) {
        case .Playing:
            vaderButton.enabled = false
            chipmunkButton.enabled = false
            stopButton.enabled = false
        case .NotPlaying:
            vaderButton.enabled = true
            chipmunkButton.enabled = true
            stopButton.enabled = true
        }
    }
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
}









