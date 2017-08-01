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
    let sampleQueue = DispatchQueue(label: "com.zweigraf.DisplayLiveSamples.sampleQueue", attributes: [])
    let faceQueue = DispatchQueue(label: "com.zweigraf.DisplayLiveSamples.faceQueue", attributes: [])
    var isFaceDetectionOff:Bool = false
    var glView:OGLView!
    
    let wrapper = DlibWrapper()
    
    var currentMetadata: [Any]
    
    let timer = Timer()
    
    var lastFaceDetectedTime:Double
    
    let FDTimeThreshold:Double = 50.0
    
    override init() {
        currentMetadata = []
        lastFaceDetectedTime = 0
        super.init()
    }
    
    func openSession() {
        let device = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
            .map { $0 as! AVCaptureDevice }
            .filter { $0.position == .front }
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
        
        
        let settings: [AnyHashable: Any] = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: Int(kCVPixelFormatType_32BGRA)]
        output.videoSettings = settings
        
        let conn:AVCaptureConnection = output.connection(withMediaType: AVMediaTypeVideo)
        conn.videoOrientation = .portrait
        
        // availableMetadataObjectTypes change when output is added to session.
        // before it is added, availableMetadataObjectTypes is empty
        metaOutput.metadataObjectTypes = [AVMetadataObjectTypeFace]
        
        wrapper?.prepare()
        
        session.startRunning()
        
        
    }
    
    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
        if !currentMetadata.isEmpty {
            
            if self.glView.isHidden {
                
                DispatchQueue.main.async(execute: {
                    self.glView.isHidden = false
                })
            }
            
            let boundsArray = currentMetadata
                .flatMap { $0 as? AVMetadataFaceObject }
                .map { NSValue(cgRect: $0.bounds) }
            let currentFaceDetectedTime = Date().timeIntervalSince1970 * 1000
            
            let diff = abs(Double(currentFaceDetectedTime - lastFaceDetectedTime))
            
            //			print(diff)
            //			print(currentFaceDetectedTime)
            
            if diff > FDTimeThreshold {
                
                wrapper?.detectFace(from: sampleBuffer, in: currentMetadata.flatMap { $0 as? AVMetadataFaceObject }.map{ $0.bounds }.first!,  in:glView)
                lastFaceDetectedTime = currentFaceDetectedTime
            }
            
        }else{
            if glView != nil {
                
                //				print(glView)
                
                if !self.glView.isHidden {
                    DispatchQueue.main.async(execute: {
                        self.glView.isHidden = true
                    })
                }
                
            }
        }
        layer.enqueue(sampleBuffer)
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didDrop sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
        //        print("DidDropSampleBuffer")
        
    }
    
    // MARK: AVCaptureMetadataOutputObjectsDelegate
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        let emptyArray:[Any]! = []
        currentMetadata = isFaceDetectionOff ? emptyArray : metadataObjects
        
        
    }
}
