//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Onyinyechukwu Uchime on 10/3/15.
//  Copyright © 2015 Michael Stockman. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    
    //Declared globally within PlaySoundsViewController

    
    //In viewDidLoad
    
    
    //In playChipmunkAudio
    
    //New Function
    
    var audioPlayer:AVAudioPlayer!
    var recievedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*if let filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
            let filePathUrl = NSURL.fileURLWithPath(filePath)
            do {
                audioPlayer = try AVAudioPlayer(contentsOfURL: filePathUrl)
                audioPlayer.enableRate = true
            } catch {
                
            }
        } else {
            print("failed to get filePath")
        }*/
        
        do {
            if (recievedAudio == nil) {
                print("PlaySoundsViewController.swift viewDidLoad() - recievedAudio == nil")
            } else {
                audioPlayer = try AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl)
                audioPlayer.enableRate = true
                audioEngine = AVAudioEngine()
                audioFile = try! AVAudioFile(forReading: recievedAudio.filePathUrl)
            }
        } catch {
            print("PlaySoundsViewController.swift viewDidLoad() - unable to play recievedAudio")
        }
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSoundSlow(sender: UIButton) {
        print("in playSoundSlow")
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = 0.5
        audioPlayer.play()
    }

    @IBAction func playSoundFast(sender: UIButton) {
        print("in playSoundFast")
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = 1.5
        audioPlayer.play()
    }
    
    @IBAction func playSoundChipmunk(sender: UIButton) {
        print("in playSoundChipmunk")
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playSoundDarthVader(sender: UIButton) {
        print("in playSoundDarthVader")
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func stopSound(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
