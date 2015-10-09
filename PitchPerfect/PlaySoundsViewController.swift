//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Michael Stockman on 10/3/15.
//  Copyright © 2015 Michael Stockman. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var recievedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudioPlayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSoundSlow(sender: UIButton) {
        playAudioWithVariableRate(0.5)
    }

    @IBAction func playSoundFast(sender: UIButton) {
        playAudioWithVariableRate(1.5)
    }
    
    @IBAction func playSoundChipmunk(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playSoundDarthVader(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func stopSound(sender: UIButton) {
        resetAudioPlayer()
    }
    
    func setupAudioPlayer() {
        if (recievedAudio == nil) {
            print("Error in PlaySoundsViewController.swift setupAudioPlayer(). Variable 'recievedAudio' is nil.")
        } else {
            audioPlayer = try! AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl)
            audioPlayer.enableRate = true
            audioEngine = AVAudioEngine()
            audioFile = try! AVAudioFile(forReading: recievedAudio.filePathUrl)
        }
    }
    
    func resetAudioPlayer() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioWithVariableRate(rate: Float) {
        resetAudioPlayer()
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        resetAudioPlayer()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
}
