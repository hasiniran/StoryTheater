//
//  Recorder.swift
//  Autism App
//
//  Created by Ben Kennel on 6/14/16.
//  Copyright © 2016 Mobile Computing Lab. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SpriteKit

class Recorder: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    var recordingSession: AVAudioSession!
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    var filename: String?
    var images: [UIImage]?
    var soundRecording: Bool
    var videoRecording: Bool
    var scene: SKScene?
    var videoURL: NSURL?
    
    init(gameScene: SKScene) {
        recordingSession = AVAudioSession.sharedInstance()
        images=[UIImage]()
        soundRecording=false
        videoRecording=false
        scene=gameScene
    }
    
    func isSoundRecording() -> Bool {return soundRecording}
    func isVideoRecording() -> Bool {return videoRecording}
    
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
    
    func startSoundRecording(filename: String) {
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { /*[unowned self]*/ (allowed: Bool) -> Void in dispatch_async(dispatch_get_main_queue()){
                if !allowed {
                    print("failed to record")
                }
                }
            }
        } catch {
            //failed to record
            print("failed to record")
        }
        
        //let audioFilename = getDocumentsDirectory().stringByAppendingPathComponent("recording.m4a")
        //let audioURL = NSURL(fileURLWithPath: audioFilename)
        let audioURL = getFileURL(filename)
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
            soundRecording=true
        } catch {
            stopSoundRecording(success: false)
        }
    }
    
    func stopSoundRecording(success success: Bool) {
        recorder.stop()
        //recorder = nil
        soundRecording=false
        if success {
            print("recording successful")
        } else {
            print("recording failed")
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            stopSoundRecording(success: false)
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
    
    func getScreenshot(scene: SKScene, frame: CGRect, bounds: CGRect) -> UIImage {
        //let snapshotView = scene.view!.snapshotViewAfterScreenUpdates(true)
        //let snapshotView=scene.view!
        //let bounds = UIScreen.mainScreen().bounds
        //let xlength=bounds.width*0.8
        //let ylength=bounds.height*0.5
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
    
        //calculate rectangle bounds based on percentage of screen size (account for different devices)
        //UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        //frame.minX,minY,maxX,maxY (CGFloat)
        //let context=UIGraphicsGetCurrentContext()
        //CGContextTranslateCTM(context, bounds.width-xlength+(bounds.width-xlength)/2, ylength)
        //print(frame.size)
        
        scene.view!.drawViewHierarchyInRect(bounds, afterScreenUpdates: true)
        //snapshotView.drawViewHierarchyInRect(bounds, afterScreenUpdates: true)
        //snapshotView.drawViewHierarchyInRect(CGRect(x: -80, y: -80, width: 900, height: 650), afterScreenUpdates: true)
        //snapshotView.drawViewHierarchyInRect(frame, afterScreenUpdates: true)
        let screenshotImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        //var screenshotImage=UIImage()
        return screenshotImage
        
    }
    
    func startVideo(scene: SKScene, frame: CGRect, bounds: CGRect) {
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
        
        // Needs to continuously take screenshots until stopVideo()
        let image: UIImage=getScreenshot(scene, frame: frame, bounds: bounds)
        images!.append(image)
        print(images!.count)
        
        videoRecording=true
        
        //let imgSprite=self.childNodeWithName("balloon") as? SKSpriteNode
        //let recordFrame=self.scene?.childNodeWithName("recordFrame") as? SKShapeNode
        //let jpeg=UIImageJPEGRepresentation(image, 20)
        //let url=getFileURL("screenshot.jpg")
        //jpeg?.writeToURL(url, atomically: true)
        
        //imgSprite!.texture=SKTexture(image: image)
        
    }
    
    func stopVideo() {
        // stop recording video
        videoRecording=false
    }

    func build(outputSize outputSize: CGSize, completionHandler: ()->()){
        /*let fileManager = NSFileManager.defaultManager()
         let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
         guard let documentDirectory: NSURL = urls.first else {
         fatalError("documentDir Error")
         }
         
         let videoOutputURL = documentDirectory.URLByAppendingPathComponent("OutputVideo.mp4")
         */
        let videoOutputURL=getFileURL("video.mp4")
        videoURL=videoOutputURL
        
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
                //Video specifications
                let fps: Int32 = 20
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
                    frameCount+=1
                }
                videoWriterInput.markAsFinished()
                videoWriter.finishWritingWithCompletionHandler { () -> Void in
                    print("FINISHED!!!!!")
                    completionHandler()
                }
            })
        } //Needs to combine audio with video - AVComposition
        
    }
    
    func merge() {
        print("merging video and audio...")
        let composition=AVMutableComposition()
        let videoTrack=composition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        let audioTrack=composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: 0)
        let videoAsset=AVURLAsset(URL: getFileURL("video.mp4"))
        let audioAsset=AVURLAsset(URL: getFileURL("recording.m4a"))
        
        let video=videoAsset.tracksWithMediaType(AVMediaTypeVideo)[0] as AVAssetTrack
        let audio=audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0] as AVAssetTrack
        
        do{
            try videoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAsset.duration), ofTrack: video, atTime: kCMTimeZero)
        } catch {
            print("Could not load video track")
        }
        do{
            try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAsset.duration), ofTrack: audio, atTime: kCMTimeZero)
        } catch {
            print("Could not load audio track")
        }
        
        guard let exporter=AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetMediumQuality) else {return}
        exporter.outputURL=getFileURL("merge.mp4")
        exporter.outputFileType=AVFileTypeMPEG4
        exporter.shouldOptimizeForNetworkUse=true
        
        exporter.exportAsynchronouslyWithCompletionHandler() {
            dispatch_async(dispatch_get_main_queue()) { _ in
                self.playVideo()
            }
        }
        
        
    }
    
    func playVideo() {
        videoURL=getFileURL("merge.mp4")
        //videoURL=NSURL(fileURLWithPath: getDocumentsDirectory().stringByAppendingPathComponent("video.mp4"))
        print("saved video URL: \(videoURL!)")
        let player = AVPlayer(URL: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        scene!.view?.window?.rootViewController!.presentViewController(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
}
