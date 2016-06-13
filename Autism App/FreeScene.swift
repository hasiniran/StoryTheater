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

    weak var viewController: UIViewController!
    var transition: SKTransition?
    var recordingSession: AVAudioSession!
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    var videoRecorder: RPScreenRecorder!
    var filename: String?
    //var videoSession: AVCaptureSession?
    //var screen: AVCaptureScreenInput?
    //var moviefile: AVCaptureMovieFileOutput?
    var images: [UIImage]?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        scene!.scaleMode = SKSceneScaleMode.ResizeFill
        viewController=self.view?.window?.rootViewController
        srand48(Int(NSDate().timeIntervalSinceReferenceDate))
        //var color: UIColor = UIColor.whiteColor()
        //print(AVCaptureDevice.devices())
        //NSLog("Devices: "+String(AVCaptureDevice.devices()))
        print(self.children)
        images=[UIImage]()
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
                                let label = node.childNodeWithName("recordText") as? SKLabelNode
                                if self.recordTapped(){
                                    label!.text="Stop Recording"
                                } else {
                                    label!.text="Record!"
                                }
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

                } else if node.name == "playbackButton" {
                    self.playRecording()
                } else if node.name == "videoRecButton" {
                    let label = node.childNodeWithName("videoRecText") as? SKLabelNode
                    if self.videoRecTapped() {
                        label!.text="Recording..."
                    } else {
                        label!.text="Rec Video"
                    }
                } else if node.name == "videoPlayButton" {
                    self.build(outputSize: CGSizeMake(1280, 720))
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
    
    func recordTapped() -> Bool{
        if recorder == nil {
            startRecording()
            return true
        } else {
            finishRecording(success: true)
            return false
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
        
        /* ReplayKit recording
        if RPScreenRecorder.sharedRecorder().available{
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
        //NSLog("start video")
        
        let image: UIImage=getScreenshot(self)
        images!.append(image)
        print(images!.count)
        let imgSprite=self.childNodeWithName("balloon") as? SKSpriteNode
        //let recordFrame=self.scene?.childNodeWithName("recordFrame") as? SKShapeNode
        //let jpeg=UIImageJPEGRepresentation(image, 20)
        //let url=getFileURL("screenshot.jpg")
        //jpeg?.writeToURL(url, atomically: true)
        
        imgSprite!.texture=SKTexture(image: image)
        
        videoRecorder = RPScreenRecorder.sharedRecorder()
        videoRecorder.startRecordingWithMicrophoneEnabled(true) { (error) in
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
            }
        }
    }
    
    func getScreenshot(scene: SKScene) -> UIImage {
        let snapshotView = scene.view!.snapshotViewAfterScreenUpdates(true)
        let bounds = UIScreen.mainScreen().bounds
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        
        snapshotView.drawViewHierarchyInRect(bounds, afterScreenUpdates: true)
        
        let screenshotImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return screenshotImage;
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
        /*do{
            let videoWriter=try AVAssetWriter(URL: getFileURL("video.m4v"), fileType: AVFileTypeAppleM4V)
            let videoSettings = [
                AVVideoCodecKey: AVVideoCodecH264,
                AVVideoWidthKey: 640,
                AVVideoHeightKey: 480
            ]
            var outputSize=CGSizeMake(1280, 720)
            let writerInput=AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: videoSettings as? [String : AnyObject])
            let sourcePixelBufferAttributesDictionary = [kCVPixelBufferPixelFormatTypeKey as String : NSNumber(unsignedInt: kCVPixelFormatType_32ARGB), kCVPixelBufferWidthKey as String: NSNumber(float: Float(outputSize.width)), kCVPixelBufferHeightKey as String: NSNumber(float: Float(outputSize.height))]
            let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writerInput, sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary)
            
            if videoWriter.canAddInput(writerInput) {
                videoWriter.addInput(writerInput)
            }
            
            videoWriter.startWriting()
            videoWriter.startSessionAtSourceTime(kCMTimeZero)
            var ciimage=CIImage(image: images![0])
            CIContext().createCGImage(ciimage!,fromRect: ciimage!.extent)
            //var cg:CGImage = CGImage(images![0])
            writerInput.appendSampleBuffer(<#T##sampleBuffer: CMSampleBuffer##CMSampleBuffer#>)
        } catch {
            print("error: cannot create AVAssetWriter")
        }*/
    }
    
    func videoRecTapped() -> Bool{
        NSLog(String(videoRecorder))
        if videoRecorder==nil{
            startVideo()
            return true
        } else {
            stopVideo()
            return false
        }
    }
    
    func build(outputSize outputSize: CGSize) {
        /*let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        guard let documentDirectory: NSURL = urls.first else {
            fatalError("documentDir Error")
        }
        
        let videoOutputURL = documentDirectory.URLByAppendingPathComponent("OutputVideo.mp4")
        */
        let videoOutputURL=getFileURL("video.mp4")
        
        if NSFileManager.defaultManager().fileExistsAtPath(videoOutputURL.path!) {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(videoOutputURL.path!)
            } catch {
                fatalError("Unable to delete file: \(error) : \(#function).")
            }
        }
        
        guard let videoWriter = try? AVAssetWriter(URL: videoOutputURL, fileType: AVFileTypeMPEG4) else {
            fatalError("AVAssetWriter error")
        }
        
        let outputSettings = [AVVideoCodecKey : AVVideoCodecH264, AVVideoWidthKey : NSNumber(float: Float(outputSize.width)), AVVideoHeightKey : NSNumber(float: Float(outputSize.height))]
        
        guard videoWriter.canApplyOutputSettings(outputSettings, forMediaType: AVMediaTypeVideo) else {
            fatalError("Negative : Can't apply the Output settings...")
        }
        
        let videoWriterInput = AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: outputSettings)
        let sourcePixelBufferAttributesDictionary = [kCVPixelBufferPixelFormatTypeKey as String : NSNumber(unsignedInt: kCVPixelFormatType_32ARGB), kCVPixelBufferWidthKey as String: NSNumber(float: Float(outputSize.width)), kCVPixelBufferHeightKey as String: NSNumber(float: Float(outputSize.height))]
        let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput, sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary)
        
        if videoWriter.canAddInput(videoWriterInput) {
            videoWriter.addInput(videoWriterInput)
        }
        
        if videoWriter.startWriting() {
            videoWriter.startSessionAtSourceTime(kCMTimeZero)
            assert(pixelBufferAdaptor.pixelBufferPool != nil)
            
            let media_queue = dispatch_queue_create("mediaInputQueue", nil)
            
            videoWriterInput.requestMediaDataWhenReadyOnQueue(media_queue, usingBlock: { () -> Void in
                let fps: Int32 = 1
                let frameDuration = CMTimeMake(1, fps)
                
                var frameCount: Int64 = 0
                var appendSucceeded = true
                
                while (!self.images!.isEmpty) {
                    if (videoWriterInput.readyForMoreMediaData) {
                        let nextPhoto = self.images!.removeAtIndex(0)
                        let lastFrameTime = CMTimeMake(frameCount, fps)
                        let presentationTime = frameCount == 0 ? lastFrameTime : CMTimeAdd(lastFrameTime, frameDuration)
                        
                        var pixelBuffer: CVPixelBuffer? = nil
                        let status: CVReturn = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pixelBufferAdaptor.pixelBufferPool!, &pixelBuffer)
                        
                        if let pixelBuffer = pixelBuffer where status == 0 {
                            let managedPixelBuffer = pixelBuffer
                            
                            CVPixelBufferLockBaseAddress(managedPixelBuffer, 0)
                            
                            let data = CVPixelBufferGetBaseAddress(managedPixelBuffer)
                            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
                            let context = CGBitmapContextCreate(data, Int(outputSize.width), Int(outputSize.height), 8, CVPixelBufferGetBytesPerRow(managedPixelBuffer), rgbColorSpace, CGImageAlphaInfo.PremultipliedFirst.rawValue)
                            
                            CGContextClearRect(context, CGRectMake(0, 0, CGFloat(outputSize.width), CGFloat(outputSize.height)))
                            
                            let horizontalRatio = CGFloat(outputSize.width) / nextPhoto.size.width
                            let verticalRatio = CGFloat(outputSize.height) / nextPhoto.size.height
                            //aspectRatio = max(horizontalRatio, verticalRatio) // ScaleAspectFill
                            let aspectRatio = min(horizontalRatio, verticalRatio) // ScaleAspectFit
                            
                            let newSize:CGSize = CGSizeMake(nextPhoto.size.width * aspectRatio, nextPhoto.size.height * aspectRatio)
                            
                            let x = newSize.width < outputSize.width ? (outputSize.width - newSize.width) / 2 : 0
                            let y = newSize.height < outputSize.height ? (outputSize.height - newSize.height) / 2 : 0
                            
                            CGContextDrawImage(context, CGRectMake(x, y, newSize.width, newSize.height), nextPhoto.CGImage)
                            
                            CVPixelBufferUnlockBaseAddress(managedPixelBuffer, 0)
                            
                            appendSucceeded = pixelBufferAdaptor.appendPixelBuffer(pixelBuffer, withPresentationTime: presentationTime)
                        } else {
                            print("Failed to allocate pixel buffer")
                            appendSucceeded = false
                        }
                    }
                    if !appendSucceeded {
                        break
                    }
                    frameCount++
                }
                videoWriterInput.markAsFinished()
                videoWriter.finishWritingWithCompletionHandler { () -> Void in
                    print("FINISHED!!!!!")
                }
            })
        }
    }
    
    func previewControllerDidFinish(previewController: RPPreviewViewController) {
        self.viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
