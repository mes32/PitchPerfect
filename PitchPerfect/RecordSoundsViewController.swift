//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Michael Stockman on 10/3/15.
//  Copyright © 2015 Michael Stockman. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    // Global variables
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    // Weakly declared global variables
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var tapToRecord: UILabel!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        showDefaultScreen()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordButton.enabled = false
        tapToRecord.hidden = true
        
        setupAudioRecorder()
        audioRecorder.record()
        
        recordingInProgress.hidden = false
        stopButton.hidden = false
    }
    
    @IBAction func stopRecordAudio(sender: UIButton) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            let url:NSURL = recorder.url
            let title:String = url.lastPathComponent!
            recordedAudio = RecordedAudio.init(url: url, name: title)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Audio recording to did not finish successfully")
            showDefaultScreen()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.recievedAudio = data
        }
    }
    
    func showDefaultScreen() {
        recordButton.enabled = true
        tapToRecord.hidden = false
        recordingInProgress.hidden = true
        stopButton.hidden = true
    }
    
    func setupAudioRecorder() {
        // Initialize audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        // Set path to recorded audio file
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let pathArray = [dirPath, "recordedAudio.wav"]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        // Initialize audio recorder
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
    }
}

