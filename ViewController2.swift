//
//  ViewController2.swift
//  High Noon: AR Western Duel
//
//  Created by Ben on 11/2/17.
//  Copyright © 2017 Ben Toth. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AudioToolbox

var redCheck = Int()
var greenCheck = Int()
var blueCheck = Int()

var redCheckFace = Int()
var greenCheckFace = Int()
var blueCheckFace = Int()

class ViewController2: UIViewController {
    var newImage = UIImage()
    let session = AVCaptureSession()
    var camera : AVCaptureDevice?
    var cameraPreviewLayer : AVCaptureVideoPreviewLayer?
    var cameraCaptureOutput : AVCapturePhotoOutput?
    var player:AVAudioPlayer = AVAudioPlayer()
    var takePhotoText = "Take Photo"
    var placeOnBody = "Shirt"
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var tester: UIImageView!
    @IBOutlet weak var seeImage: UIImageView!
    @IBOutlet weak var getShirtColor: UIButton!
    var getShirtColorHeight = CGFloat()
    var getShirtColorWidth = CGFloat()
    var testerHeight = CGFloat()
    var testerWidth = CGFloat()
    var takePhotoButtonHeight = CGFloat()
    var takePhotoButtonWidth = CGFloat()
    var nextButtonHeight = CGFloat()
    var nextButtonWidth = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCaptureSession()
        seeImage.isHidden = true
        getShirtColorHeight = CGFloat(view.frame.height / 4)
        //getShirtColorWidth = CGFloat(view.frame.width / 1.2)
        //getShirtColor.frame = CGRect(x: (view.frame.width / 2) - getShirtColorWidth / 2, y: (view.frame.height / 6) - getShirtColorHeight / 2, width: getShirtColorWidth, height: getShirtColorHeight)
        getShirtColorWidth = CGFloat(view.frame.width)
        getShirtColor.frame = CGRect(x: 0, y: 0, width: getShirtColorWidth, height: getShirtColorHeight)
        seeImage.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        testerHeight = CGFloat(view.frame.height / 9)
        testerWidth = testerHeight
        tester.frame = CGRect(x: (view.frame.width / 2) - testerWidth / 2, y: (view.frame.height / 2) - testerHeight, width: testerWidth, height: testerHeight)
        takePhotoButtonHeight = CGFloat(view.frame.height / 9)
        takePhotoButtonWidth = CGFloat(view.frame.width / 3)
        takePhotoButton.frame = CGRect(x: (view.frame.width / 2) - takePhotoButtonWidth / 2, y: (view.frame.height / 1.4) - takePhotoButtonHeight / 2, width: takePhotoButtonWidth, height: takePhotoButtonHeight)
        nextButtonHeight = CGFloat(view.frame.height / 9)
        nextButtonWidth = CGFloat(view.frame.width / 3)
        nextButton.frame = CGRect(x:(view.frame.width / 2) - nextButtonWidth / 2, y: (view.frame.height / 1.15) - nextButtonHeight / 2, width: nextButtonWidth , height: nextButtonHeight)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func takePhoto(_ sender: Any) {
        if takePhotoText == "Take Photo" {
            takePicture()
        } else {
            takePhotoText = "Take Photo"
            takePhotoButton.setTitle("Take Photo", for: UIControlState.normal )
            seeImage.isHidden = true
            
        }
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        if takePhotoText == "Retry" {
        if placeOnBody == "Shirt" {
            getShirtColor.setTitle("Get Face Color", for: UIControlState.normal)
            testPhot()
            placeOnBody = "Face"
            takePhotoButton.setTitle("Take Photo", for: UIControlState.normal)
        } else {
            performSegue(withIdentifier: "next", sender: nil)
            print(redCheckFace)
            print(redCheck)
        }
    }
    }
    
    
    func setImage() {
        seeImage.image = newImage
        takePhotoButton.setTitle("Retry", for: UIControlState.normal)
        takePhotoText = "Retry"
        seeImage.isHidden = false
    }

    func testPhot() {
        if takePhotoText == "Take Photo" {
            takePicture()
        } else {
            takePhotoText = "Take Photo"
            seeImage.isHidden = true
        }
        
    }
    func initializeCaptureSession() {
        
        session.sessionPreset = AVCaptureSession.Preset.high
        camera = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let cameraCaptureInput = try AVCaptureDeviceInput(device: camera!)
            cameraCaptureOutput = AVCapturePhotoOutput()
            
            session.addInput(cameraCaptureInput)
            session.addOutput(cameraCaptureOutput!)
            
        } catch {
            print(error.localizedDescription)
        }
        
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.frame = view.bounds
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        
        view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
        session.startRunning()
    }
    
    
    func takePicture() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .off
        cameraCaptureOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    


}



extension ViewController2 : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error { print("Error:", error) }
        else {
            let imageData = photo.fileDataRepresentation()
            if let finalImage = UIImage(data: imageData!) {
                newImage = finalImage.resizeImage(image: finalImage)
                let place = CGPoint(x: newImage.size.width / 2, y: newImage.size.height/2)
                //Make sure point is within the image
                let color = newImage.getPixelColor(pos: place)
                if placeOnBody == "Shirt" {
                redCheck = red
                greenCheck = green
                blueCheck = blue
                } else {
                redCheckFace = red
                greenCheckFace = green
                blueCheckFace = blue
                }
                print(color)
                setImage()
            }
        }
    }
}


