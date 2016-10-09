//
//  SessionHandler.swift
//  DisplayLiveSamples
//
//  Created by Luis Reisewitz on 15.05.16.
//  Copyright © 2016 ZweiGraf. All rights reserved.
//

import AVFoundation

class SessionHandler : NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate {
    var session = AVCaptureSession()
    let layer = AVSampleBufferDisplayLayer()
    let sampleQueue = dispatch_queue_create("com.zweigraf.DisplayLiveSamples.sampleQueue", DISPATCH_QUEUE_SERIAL)
    let faceQueue = dispatch_queue_create("com.zweigraf.DisplayLiveSamples.faceQueue", DISPATCH_QUEUE_SERIAL)
	var isFaceDetectionOff:Bool = false
	var glView:OGLView!
	
    let wrapper = DlibWrapper()
    
    var currentMetadata: [AnyObject]
	
	let timer = NSTimer()
	
	var lastFaceDetectedTime:Double
	
	let FDTimeThreshold:Double = 50.0
    
    override init() {
        currentMetadata = []
		lastFaceDetectedTime = 0
        super.init()
    }
    
    func openSession() {
        let device = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
            .map { $0 as! AVCaptureDevice }
            .filter { $0.position == .Front }
            .first!
        
        let input = try! AVCaptureDeviceInput(device: device)
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: sampleQueue)
        
        let metaOutput = AVCaptureMetadataOutput()
        metaOutput.setMetadataObjectsDelegate(self, queue: faceQueue)

		
        if session.canAddInput(input) {
            session.addInput(input)
        }
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        if session.canAddOutput(metaOutput) {
            session.addOutput(metaOutput)
        }

		
        let settings: [NSObject : AnyObject] = [kCVPixelBufferPixelFormatTypeKey: Int(kCVPixelFormatType_32BGRA)]
        output.videoSettings = settings
		
		let conn:AVCaptureConnection = output.connectionWithMediaType(AVMediaTypeVideo)
		conn.videoOrientation = .Portrait
		
        // availableMetadataObjectTypes change when output is added to session.
        // before it is added, availableMetadataObjectTypes is empty
        metaOutput.metadataObjectTypes = [AVMetadataObjectTypeFace]
        
        wrapper.prepare()
        
        session.startRunning()
		
		
    }
    
    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        
        if !currentMetadata.isEmpty {
			
			if self.glView.hidden {
				
				dispatch_async(dispatch_get_main_queue(), {
					self.glView.hidden = false
					})
			}
			
            let boundsArray = currentMetadata
                .flatMap { $0 as? AVMetadataFaceObject }
                .map { NSValue(CGRect: $0.bounds) }
			let currentFaceDetectedTime = NSDate().timeIntervalSince1970 * 1000
			
			let diff = abs(Double(currentFaceDetectedTime - lastFaceDetectedTime))
			
//			print(diff)
//			print(currentFaceDetectedTime)
			
			if diff > FDTimeThreshold {
		
				wrapper.detectFaceFromSampleBuffer(sampleBuffer, inRect: currentMetadata.flatMap { $0 as? AVMetadataFaceObject }.map{ $0.bounds }.first!,  inGLView:glView)
				lastFaceDetectedTime = currentFaceDetectedTime
			}
			
		}else{
			if glView != nil {
				
//				print(glView)
				
				if !self.glView.hidden {
					dispatch_async(dispatch_get_main_queue(), {
						self.glView.hidden = true
					})
				}
		
			}
		}
      layer.enqueueSampleBuffer(sampleBuffer)
		
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didDropSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
		
//        print("DidDropSampleBuffer")
		
    }
    
    // MARK: AVCaptureMetadataOutputObjectsDelegate
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
		
	
			currentMetadata = isFaceDetectionOff ? [] : metadataObjects

		
    }
}
