//
//  ViewController3.swift
//  High Noon: AR Western Duel
//
//  Created by Ben on 11/2/17.
//  Copyright © 2017 Ben Toth. All rights reserved.
//
import MultipeerConnectivity
import Foundation
import UIKit
import AVFoundation
import AudioToolbox


var youWin = Bool()


class ViewController3: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var newImage = UIImage()
    let session = AVCaptureSession()
    var camera : AVCaptureDevice?
    var cameraPreviewLayer : AVCaptureVideoPreviewLayer?
    var cameraCaptureOutput : AVCapturePhotoOutput?
    var player:AVAudioPlayer = AVAudioPlayer()
    var isGunLoaded = true
    var gunImageName = String()
    var bulletCount = Int()
    var bulletCountReachedMax = false
    var connectButtonHeight = CGFloat()
    var connectButtonWidth = CGFloat()
    var holsterWeaponHeight = CGFloat()
    var holsterWeaponWidth = CGFloat()
    var gunViewHeight = CGFloat()
    var gunViewWidth = CGFloat()
    var shootButtonHeight = CGFloat()
    var shootButtonWidth = CGFloat()
    var timer = Timer()
    var timer2 = Timer()
    var timeReadySetFire = Int()
    var bulletWidthHeight = CGFloat()
    var revolverIsBeingReloaded = false
    var connectIsPressed = false
    var gunCock = AVAudioPlayer()
    var gunFire = AVAudioPlayer()
    var gunEmpty = AVAudioPlayer()
    
    @IBOutlet weak var hostAndJoinButton: UIButton!
    @IBOutlet weak var gunView: UIImageView!
    @IBOutlet weak var shootButton: UIButton!
    @IBOutlet weak var middleTopBullet: UIButton!
    @IBOutlet weak var rightTopBullet: UIButton!
    @IBOutlet weak var rightBottomBullet: UIButton!
    @IBOutlet weak var middleBottomBullet: UIButton!
    @IBOutlet weak var leftBottomBullet: UIButton!
    @IBOutlet weak var leftTopBullet: UIButton!
    @IBOutlet weak var holsterWeaponLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCaptureSession()
        holsterWeaponLabel.isHidden = true
        holsterWeaponLabel.text = "Holster phone and begin on vibrate"
        gunView.isHidden = true
        connectIsPressed = false
        peerID = MCPeerID(displayName: UIDevice.current.name)
        timeReadySetFire = 8
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        if hostOrNot == true {
            hostAndJoinButton.setTitle("Host Duel", for: UIControlState.normal)
        } else {
            hostAndJoinButton.setTitle("Join Duel", for: UIControlState.normal)
        }
        bulletCount = 1
        gunImageName = "revolver\(bulletCount)"
        
        gunViewHeight = CGFloat(view.frame.height / 2)
        gunViewWidth = CGFloat(view.frame.height / 5)
        gunView.frame = CGRect(x: (view.frame.width / 2) - gunViewWidth / 2, y: (view.frame.height / 2), width: gunViewWidth, height: gunViewHeight)
        
        connectButtonHeight = CGFloat(view.frame.height / 6)
        connectButtonWidth = CGFloat(view.frame.width / 2)
        hostAndJoinButton.frame = CGRect(x: (view.frame.width / 2) - connectButtonWidth / 2 , y: (view.frame.height / 2) - connectButtonHeight / 2, width: connectButtonWidth, height: connectButtonHeight)
        
        shootButtonHeight = CGFloat(view.frame.height)
        shootButtonWidth = CGFloat(view.frame.width)
        shootButton.frame = CGRect(x: (view.frame.width / 2) - shootButtonWidth / 2, y: (view.frame.height / 2) - shootButtonHeight / 2, width: shootButtonWidth, height: shootButtonHeight)
        
        holsterWeaponHeight = CGFloat(view.frame.height * 0.0315)
        holsterWeaponWidth = CGFloat(view.frame.width)
        holsterWeaponLabel.frame = CGRect(x: (view.frame.width / 2) - holsterWeaponWidth / 2, y: (view.frame.height * 0.2564) - holsterWeaponHeight / 2, width: holsterWeaponWidth, height: holsterWeaponHeight)
        
        
        middleTopBullet.isHidden = true
        middleBottomBullet.isHidden = true
        leftTopBullet.isHidden = true
        leftBottomBullet.isHidden = true
        rightTopBullet.isHidden = true
        rightBottomBullet.isHidden = true
        
        do {
            gunCock = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Gun+Cock", ofType: "mp3")!))
            gunCock.prepareToPlay()
        } catch {
            print(error)
        }
        do {
            gunFire = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Gun+Shot2", ofType: "mp3")!))
            gunFire.prepareToPlay()
        } catch {
            print(error)
        }
        do {
            gunEmpty = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Gun+Empty", ofType: "mp3")!))
            gunEmpty.prepareToPlay()
        } catch {
            print(error)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @objc func showConnectionPromptJoin() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .actionSheet)
        //ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    @objc func showConnectionPromptHost() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        //ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func startHosting(action: UIAlertAction) {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
        connectIsPressed = true
        hostAndJoinButton.setTitle("Tap At Same Time To Start", for: UIControlState.normal)

    }
    
    func joinSession(action: UIAlertAction) {
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
        connectIsPressed = true
        hostAndJoinButton.setTitle("Tap At Same Time To Start", for: UIControlState.normal)

    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    func setTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController3.readySetFire), userInfo: nil, repeats: true)
        print("test")
    }
    
    @objc func readySetFire() {
        print("test")
        if timeReadySetFire == 0 {
        timer.invalidate()
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        holsterWeaponLabel.isHidden = true
        } else {
         timeReadySetFire -= 1
        }
    }
    
    func hitTimer() {
        holsterWeaponLabel.isHidden = false
        print("test")
        holsterWeaponLabel.text = "Hit!"
        timer2 = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(ViewController3.hit), userInfo: nil, repeats: false)
    }
    
    @objc func hit() {
        holsterWeaponLabel.isHidden = true
    }
    
    func headshotTimer() {
        holsterWeaponLabel.isHidden = false
        holsterWeaponLabel.text = "Headshot!"
        timer2 = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(ViewController3.headshot), userInfo: nil, repeats: false)
    }
    
    @objc func headshot() {
        holsterWeaponLabel.isHidden = true
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let color = String(data: data, encoding: .utf8) {
            if color == "You Lose" {
                performSegue(withIdentifier: "you win", sender: nil)
                youWin = false
                print("I lose")
                
            }
        }
    } //sending data
    
    func send(colorNumbers : String) {
        if mcSession.connectedPeers.count > 0 {
            do {
                try mcSession.send(colorNumbers.data(using: .utf8)!, toPeers: mcSession.connectedPeers, with: .reliable)
            }
            catch let error as NSError {
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
                
            }
        }
        
    }
    
    //camera part
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
        gunFire.play()
    }
    
    
    
    @IBAction func hostOrJoin(_ sender: Any) {
        if connectIsPressed == false {
        if hostOrNot == true {
            showConnectionPromptHost()
        } else {
            showConnectionPromptJoin()
        }
        } else {
            hostAndJoinButton.isHidden = true
            gunView.isHidden = false
            gunView.image = UIImage(named: gunImageName)
            setTimer()
            holsterWeaponLabel.isHidden = false
        }
        
    }
    var health = 100
    func getColorThenSend() {
        var red2 = Int()
        var green2 = Int()
        var blue2 = Int()
        red2 = red
        green2 = green
        blue2 = blue
        let number = Double(redCheck) * 1.08 / (Double(blueCheck) + Double(red) + Double(greenCheck)) //1.02
        let number2 = Double(redCheck) * 0.92 / (Double(blueCheck) + Double(redCheck) + Double(greenCheck)) //0.98
        let number3 = Double(redCheckFace) * 1.08 / (Double(blueCheckFace) + Double(redCheckFace) + Double(greenCheckFace)) //1.02
        let number4 = Double(redCheckFace) * 0.92 / (Double(blueCheckFace) + Double(redCheckFace) + Double(greenCheckFace)) //0.98
        if number2 <= Double(red2) / (Double(blue2) + Double(red2) + Double(green2)),  Double(red2) / (Double(blue2) + Double(red2) + Double(green2)) <= number {
            health -= 10
            print(health)
            
            if health <= 0 {
                send(colorNumbers: "You Lose")
                performSegue(withIdentifier: "you lose", sender: nil)
                youWin = true
            }
            hitTimer()
        } else {
            if number4 <= Double(red2) / (Double(blue2) + Double(red2) + Double(green2)),  Double(red2) / (Double(blue2) + Double(red2) + Double(green2)) <= number3 {
                health -= 15
                print(health)
                
                if health <= 0 {
                    send(colorNumbers: "You Lose")
                    performSegue(withIdentifier: "you lose", sender: nil)
                    youWin = true
                }
                headshotTimer()
        }
        }
    }
    var isGunLoading = false
    @IBOutlet weak var testerer: UIButton!

    @IBAction func shot(_ sender: Any) {
        if bulletCountReachedMax == true {
            gunEmpty.play()
        }
        if timeReadySetFire <= 0 {
        if bulletCountReachedMax == false {
        if revolverIsBeingReloaded == false {
        if isGunLoading == false {
            if isGunLoaded == true {
                takePicture() //test
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                isGunLoaded = false
                if bulletCount <= 10 {
                bulletCount += 1
                } else {
                bulletCount -= 1
                bulletCountReachedMax = true
                }
                gunImageName = "revolver\(bulletCount)"
                gunView.image = UIImage(named: gunImageName)
            }
                    }
                }
            }
        }
    }
    
    @IBAction func pressDown(_ sender: Any) {
        if revolverIsBeingReloaded == false {
        if isGunLoaded == false {
            isGunLoading = true
        } else {
            isGunLoading = false
        }
        }
    }
    
    @IBAction func downSwipe(_ sender: UISwipeGestureRecognizer) {
        if revolverIsBeingReloaded == false {
        print("completed")
        if isGunLoaded == false {
        isGunLoaded = true
            bulletCount += 1
        gunImageName = "revolver\(bulletCount)"
        gunCock.play()
        gunView.image = UIImage(named: gunImageName)
            //gunView = UIImageView(image: gunImageName)

        }
        }
    }
    
    
    

    
    //reloading
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if revolverIsBeingReloaded == false {
            if bulletCount >= 2 {
                middleTopBullet.isHidden = false
                middleBottomBullet.isHidden = false
                leftTopBullet.isHidden = false
                leftBottomBullet.isHidden = false
                rightTopBullet.isHidden = false
                rightBottomBullet.isHidden = false
            let bulletUnfilled = UIImage(named: "")
                if bulletCount == 2 || bulletCount == 3 {
                    middleTopBullet.setImage(bulletFilled, for: .normal)
                    middleBottomBullet.setImage(bulletFilled, for: .normal)
                    rightTopBullet.setImage(bulletFilled, for: .normal)
                    rightBottomBullet.setImage(bulletFilled, for: .normal)
                    leftTopBullet.setImage(bulletUnfilled, for: .normal)
                    leftBottomBullet.setImage(bulletFilled, for: .normal)
                    sixBullet = 5
                    print("why")
                }
                if bulletCount == 4 || bulletCount == 5 {
                    middleTopBullet.setImage(bulletFilled, for: .normal)
                    middleBottomBullet.setImage(bulletFilled, for: .normal)
                    rightTopBullet.setImage(bulletFilled, for: .normal)
                    rightBottomBullet.setImage(bulletFilled, for: .normal)
                    leftTopBullet.setImage(bulletUnfilled, for: .normal)
                    leftBottomBullet.setImage(bulletUnfilled, for: .normal)
                    sixBullet = 4
                }
                if bulletCount == 6 || bulletCount == 7 {
                    middleTopBullet.setImage(bulletFilled, for: .normal)
                    middleBottomBullet.setImage(bulletUnfilled, for: .normal)
                    rightTopBullet.setImage(bulletFilled, for: .normal)
                    rightBottomBullet.setImage(bulletFilled, for: .normal)
                    leftTopBullet.setImage(bulletUnfilled, for: .normal)
                    leftBottomBullet.setImage(bulletUnfilled, for: .normal)
                    sixBullet = 3
                }
                if bulletCount == 8 || bulletCount == 9 {
                    middleTopBullet.setImage(bulletFilled, for: .normal)
                    middleBottomBullet.setImage(bulletUnfilled, for: .normal)
                    rightTopBullet.setImage(bulletFilled, for: .normal)
                    rightBottomBullet.setImage(bulletUnfilled, for: .normal)
                    leftTopBullet.setImage(bulletUnfilled, for: .normal)
                    leftBottomBullet.setImage(bulletUnfilled, for: .normal)
                    sixBullet = 2
                }
                if bulletCount == 10 || bulletCount == 11 {
                    if bulletCountReachedMax == true {
                        middleTopBullet.setImage(bulletUnfilled, for: .normal)
                        middleBottomBullet.setImage(bulletUnfilled, for: .normal)
                        rightTopBullet.setImage(bulletUnfilled, for: .normal)
                        rightBottomBullet.setImage(bulletUnfilled, for: .normal)
                        leftTopBullet.setImage(bulletUnfilled, for: .normal)
                        leftBottomBullet.setImage(bulletUnfilled, for: .normal)
                        sixBullet = 0
                    } else {
                        middleTopBullet.setImage(bulletFilled, for: .normal)
                        middleBottomBullet.setImage(bulletUnfilled, for: .normal)
                        rightTopBullet.setImage(bulletUnfilled, for: .normal)
                        rightBottomBullet.setImage(bulletUnfilled, for: .normal)
                        leftTopBullet.setImage(bulletUnfilled, for: .normal)
                        leftBottomBullet.setImage(bulletUnfilled, for: .normal)
                        sixBullet = 1
                    }
                }
        let secondGunViewWidth = CGFloat(view.frame.height / 3.5)
        gunImageName = "revolverReloading"
        gunView.image = UIImage(named: gunImageName)
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        gunView.frame = CGRect(x: (view.frame.width / 2) - gunViewWidth / 2, y: (view.frame.height / 2), width: secondGunViewWidth, height: gunViewHeight)
        bulletWidthHeight = view.frame.height / 25
        middleTopBullet.frame = CGRect(x: (view.frame.height * 0.287) - bulletWidthHeight / 2, y: (view.frame.height / 1.8) - bulletWidthHeight / 2, width: bulletWidthHeight, height: bulletWidthHeight)
        middleBottomBullet.frame = CGRect(x: (view.frame.height * 0.287) - bulletWidthHeight / 2, y: (view.frame.height / 1.425) - bulletWidthHeight / 2, width: bulletWidthHeight, height: bulletWidthHeight)
        rightTopBullet.frame = CGRect(x: (view.frame.height * 0.3334) - bulletWidthHeight / 2, y: (view.frame.height / 1.68) - bulletWidthHeight / 2, width: bulletWidthHeight, height: bulletWidthHeight)
        rightBottomBullet.frame = CGRect(x: (view.frame.height * 0.3334) - bulletWidthHeight / 2, y: (view.frame.height / 1.5) - bulletWidthHeight / 2, width: bulletWidthHeight, height: bulletWidthHeight)
        leftTopBullet.frame = CGRect(x: (view.frame.height * 0.2284) - bulletWidthHeight / 2, y: (view.frame.height / 1.68) - bulletWidthHeight / 2, width: bulletWidthHeight, height: bulletWidthHeight)
        leftBottomBullet.frame = CGRect(x: (view.frame.height * 0.2284) - bulletWidthHeight / 2, y:(view.frame.height / 1.5) - bulletWidthHeight / 2 , width: bulletWidthHeight, height: bulletWidthHeight)
        revolverIsBeingReloaded = true
            }
            
            
        } else {
        if sixBullet >= 1 {
        middleTopBullet.isHidden = true
        middleBottomBullet.isHidden = true
        leftTopBullet.isHidden = true
        leftBottomBullet.isHidden = true
        rightTopBullet.isHidden = true
        rightBottomBullet.isHidden = true
        gunView.frame = CGRect(x: (view.frame.width / 2) - gunViewWidth / 2, y: (view.frame.height / 2), width: gunViewWidth, height: gunViewHeight)
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        revolverIsBeingReloaded = false
        isGunLoaded = false
        bulletCountReachedMax = false
        if sixBullet == 6 {
            sixBullet = 0
            bulletCount = 0
        }
        if sixBullet == 5 {
            sixBullet = 0
            bulletCount = 2
        }
        if sixBullet == 4 {
            sixBullet = 0
            bulletCount = 4
        }
        if sixBullet == 3 {
           sixBullet = 0
            bulletCount = 6
        }
        if sixBullet == 2 {
            sixBullet = 0
            bulletCount = 8
        }
        if sixBullet == 1 {
            sixBullet = 0
            bulletCount = 10
        }
            gunImageName = "revolver\(bulletCount)"
            gunView.image = UIImage(named: gunImageName)
            mTopTouched = false
            mBottomTouched = false
            rTopTouched = false
            rBottomTouched = false
            lTopTouched = false
            lBottomTouched = false
            }
            //all is shake motion
        }
    }
    
    let bulletFilled = UIImage(named: "Bullet Filled")
    var sixBullet = 0
    var mTopTouched = false
    var mBottomTouched = false
    var rTopTouched = false
    var rBottomTouched = false
    var lTopTouched = false
    var lBottomTouched = false

    @IBAction func middleTopButton(_ sender: Any) {
        if mTopTouched == false {
        middleTopBullet.setImage(bulletFilled, for: .normal)
        sixBullet += 1
        mTopTouched = true
        }
    }
    @IBAction func middleBottomButton(_ sender: Any) {
        if mBottomTouched == false {
        middleBottomBullet.setImage(bulletFilled, for: .normal)
        sixBullet += 1
        mBottomTouched = true
        }
    }
    @IBAction func rightTopButton(_ sender: Any) {
        if rTopTouched == false {
        rightTopBullet.setImage(bulletFilled, for: .normal)
        sixBullet += 1
        rTopTouched = true
        }
    }
    @IBAction func rightBottomButton(_ sender: Any) {
        if rBottomTouched == false {
        rightBottomBullet.setImage(bulletFilled, for: .normal)
        sixBullet += 1
        rBottomTouched = true
        }
    }
    @IBAction func leftTopButton(_ sender: Any) {
        if lTopTouched == false {
        leftTopBullet.setImage(bulletFilled, for: .normal)
        sixBullet += 1
        lTopTouched = true
        }
    }
    @IBAction func leftBottomButton(_ sender: Any) {
        if lBottomTouched == false {
        leftBottomBullet.setImage(bulletFilled, for: .normal)
        sixBullet += 1
        lBottomTouched = true
        }
    }
    
    
    
   
    
    
    
}


extension ViewController3 : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error { print("Error:", error) }
        else {
            let imageData = photo.fileDataRepresentation()
            if let finalImage = UIImage(data: imageData!) {
                newImage = finalImage.resizeImage(image: finalImage)
                let place = CGPoint(x: newImage.size.width / 2, y: newImage.size.height/2)
                //Make sure point is within the image
                let color = newImage.getPixelColor(pos: place)
                print(color)
                getColorThenSend()
            }
        }
    }
}


