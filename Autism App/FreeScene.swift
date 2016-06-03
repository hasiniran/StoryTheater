//
//  FreeScene.swift
//  Autism App
//
//  Created by Henry Long on 6/2/16.
//  Copyright © 2016 Mobile Computing Lab. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class FreeScene: SKScene, AVAudioRecorderDelegate{

    var transition: SKTransition?
    var recordingSession: AVAudioSession!
    var recorder: AVAudioRecorder!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        scene!.scaleMode = SKSceneScaleMode.ResizeFill
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let nodes = self.nodesAtPoint(location) as [SKNode]
            
            for node in nodes {
                if node.name == "backArrow" {
                    transition = SKTransition.revealWithDirection(.Up, duration: 1.0)
                    
                    let nextScene = GameScene(fileNamed: "GameScene")
                    nextScene!.scaleMode = .AspectFill
                    
                    scene?.view?.presentScene(nextScene!, transition: transition!)
                } else if node.name == "recordButton" {
                    //start recording (experiment)
                    //print("recordButton pressed")
                    //navigationITem.backBarButtonItem = UIBarButtonItem(title:"Record",style: .Plain, target:nil,action:nil)
                    recordingSession = AVAudioSession.sharedInstance()
                    
                    do {
                        try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                        try recordingSession.setActive(true)
                        recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in dispatch_async(dispatch_get_main_queue()){
                            if allowed {
                                self.recordTapped()
                                //print("starting recording...")
                            } else {
                                //failed to record
                                print("failed to record")
                            }
                            }
                        }
                    } catch {
                                //failed to record
                        print("failed to record")
                    }
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
        let documentsDirectory = paths[0]
        print(documentsDirectory)
        return documentsDirectory
    }
    
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().stringByAppendingPathComponent("recording.m4a")
        let audioURL = NSURL(fileURLWithPath: audioFilename)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
        ]
        do {
            recorder = try AVAudioRecorder(URL: audioURL, settings: settings)
            recorder.delegate=self
            recorder.record()
            print("starting recording...")
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success success: Bool) {
        recorder.stop()
        recorder = nil
        if success {
            print("recording successful")
        } else {
            print("recording failed")
        }
    }
    
    func recordTapped() {
        if recorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}
