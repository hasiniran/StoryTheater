//
//  FreeScene.swift
//  Autism App
//
//  Created by Henry Long on 6/2/16.
//  Copyright © 2016 Mobile Computing Lab. All rights reserved.
//

import UIKit
import SpriteKit
import Foundation
import AVFoundation
import ReplayKit
//import ScreenCapture

class FreeScene: SKScene, AVAudioRecorderDelegate, AVAudioPlayerDelegate, RPPreviewViewControllerDelegate/*, AVCaptureFileOutputRecordingDelegate*/ {

    var viewController: UIViewController!
    var transition: SKTransition?
    var recordingSession: AVAudioSession!
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    var videoRecorder: RPScreenRecorder!
    var filename: String?
    var videoSession: AVCaptureSession?
    //var screen: AVCaptureScreenInput?
    var moviefile: AVCaptureMovieFileOutput?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        scene!.scaleMode = SKSceneScaleMode.ResizeFill
        viewController=self.view?.window?.rootViewController
        srand48(Int(NSDate().timeIntervalSinceReferenceDate))
        //var color: UIColor = UIColor.whiteColor()
        //print(AVCaptureDevice.devices())
        //NSLog("Devices: "+String(AVCaptureDevice.devices()))
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
                    //Needs to refer to textnode, not button node
                    /*if let button = node as? SKShapeNode {
                        if button.fillColor == UIColor.whiteColor(){
                            button.fillColor=UIColor.grayColor()
                        } else if button.fillColor == UIColor.grayColor() {
                            button.fillColor=UIColor.whiteColor()
                        }
                    }*/
                } else if node.name == "playbackButton" {
                    self.playRecording()
                } else if node.name == "videoRecButton" {
                    self.videoRecTapped()
                } else if node.name == "background" {
                    if let bg = node as? SKSpriteNode {
                        bg.color=UIColor.init(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: CGFloat(drand48()))
                    }
                }
                if let button = node as? SKShapeNode {
                    if button.fillColor == UIColor.whiteColor(){
                        print("change color")
                        button.fillColor=UIColor.grayColor()
                    } else if button.fillColor == UIColor.grayColor() {
                        button.fillColor=UIColor.whiteColor()
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
    
    func getCacheDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true) as [String]
        let directory = paths[0]
        print(directory)
        return directory
    }
    
    func getFileURL(ext: String) -> NSURL {
        //let path = getDocumentsDirectory().stringByAppendingPathComponent(filename!)
        let path = getDocumentsDirectory().stringByAppendingPathComponent(ext)
        let filepath = NSURL(fileURLWithPath: path)
        return filepath
    }
    
    func startRecording() {
        //let audioFilename = getDocumentsDirectory().stringByAppendingPathComponent("recording.m4a")
        //let audioURL = NSURL(fileURLWithPath: audioFilename)
        let audioURL = getFileURL("recording.m4a")
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
    
    func playRecording() {
        //var error: NSError?
        do{
            player = try AVAudioPlayer(contentsOfURL: getFileURL("recording.m4a"))
            player.delegate=self
            player.play()
            print("playing audio...")
        } catch {
            print("AVAudioPlayer error")
        }
    }
    
    func stopPlaying() {
        player.stop()
        print("playback stopped")
        player = nil
    }
    
    func playbackTapped() {
        if player == nil {
            playRecording()
        } else {
            stopPlaying()
        }
    }
    
    func startVideo() {
        //videoSession=AVCaptureSession()
        //moviefile=AVCaptureMovieFileOutput()
        //var outpath=getFileURL("capture.mp4")
        //var screenInput=AVCaptureInput()
        
        /*if RPScreenRecorder.sharedRecorder().available{
            videoRecorder = RPScreenRecorder.sharedRecorder()
            videoRecorder.startRecordingWithMicrophoneEnabled(true){ (error) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    print("recording video")
                    //change label to indicate recording in progress
                }
            }
        } else {
            print("error: video recording not available")
        }*/
        NSLog("start video")
        videoRecorder = RPScreenRecorder.sharedRecorder()
        videoRecorder.startRecordingWithMicrophoneEnabled(true) { (error) in
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
            }
        }
    }
    
    func stopVideo() {
        videoRecorder = RPScreenRecorder.sharedRecorder()
        NSLog("stopping video")
        videoRecorder.stopRecordingWithHandler{ [unowned self] (preview, error) in
            if let unwrappedPreview = preview {
                unwrappedPreview.previewControllerDelegate = self
                self.viewController.presentViewController(unwrappedPreview, animated: true, completion: nil)
            }
        /*videoRecorder.stopRecordingWithHandler { (previewController: RPPreviewViewController?, error: NSError?) -> Void in
            if error != nil{
                print("error... or so mething")
            }
            if previewController != nil {
                let alertController = UIAlertController(title: "Recording", message: "Discard or view recording?", preferredStyle: .Alert)
                let discardAction = UIAlertAction(title: "Discard", style: .Default){ (action: UIAlertAction) in
                    self.videoRecorder.discardRecordingWithHandler({() -> Void in
                    })
                }
                let viewAction = UIAlertAction(title: "View", style: .Default, handler: { (action: UIAlertAction) -> Void in
                    UIViewController().presentViewController(previewController!, animated: true, completion: nil)
                })
                alertController.addAction(discardAction)
                alertController.addAction(viewAction)
                UIViewController().presentViewController(alertController, animated: true, completion: nil)
                
            }*/
        }
        videoRecorder=nil
    }
    
    func videoRecTapped() {
        NSLog(String(videoRecorder))
        if videoRecorder==nil{
            startVideo()
        } else {
            stopVideo()
        }
    }
    
    //func previewControllerDidFinish(previewController: RPPreviewViewController) {
    //    dismissViewControllerAnimated(true, completion: nil)
    //}
    
}
