//
//  ViewController.swift
//  High Noon: AR Western Duel
//
//  Created by Ben on 11/2/17.
//  Copyright © 2017 Ben Toth. All rights reserved.
//

import UIKit

var hostOrNot = true

class ViewController: UIViewController {
    @IBOutlet weak var westernDuelLabel: UIButton!
    @IBOutlet weak var hostButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var sandyBackGround: UIImageView!
    var hostButtonHeight = CGFloat()
    var hostButtonWidth = CGFloat()
    var joinButtonHeight = CGFloat()
    var joinButtonWidth = CGFloat()
    var westernDuelHeight = CGFloat()
    var westernDuelWidth = CGFloat()
    var sandyBackgroundHeight = CGFloat()
    var sandyBackgroundWidth = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hostButtonHeight = CGFloat(view.frame.height / 6)
        hostButtonWidth = CGFloat(view.frame.width / 2)
        hostButton.frame = CGRect(x: (view.frame.width / 2) - hostButtonWidth / 2 , y: (view.frame.height / 2) - hostButtonHeight / 2, width: hostButtonWidth, height: hostButtonHeight)

        joinButtonHeight = CGFloat(view.frame.height / 6)
        joinButtonWidth = CGFloat(view.frame.width / 2)
        joinButton.frame = CGRect(x: (view.frame.width / 2) - joinButtonWidth / 2, y:(view.frame.height / 1.25) - joinButtonHeight / 2, width: joinButtonWidth, height: joinButtonHeight )
        sandyBackGround.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        westernDuelHeight = CGFloat(view.frame.height / 4)
        //westernDuelWidth = CGFloat(view.frame.width / 1.2)
       // westernDuelLabel.frame = CGRect(x: (view.frame.width / 2) - westernDuelWidth / 2, y: (view.frame.height / 6) - westernDuelHeight / 2, width: westernDuelWidth, height: westernDuelHeight)
        westernDuelWidth = CGFloat(view.frame.width)
        westernDuelLabel.frame = CGRect(x: 0, y: 0, width: westernDuelWidth, height: westernDuelHeight)
        sandyBackgroundHeight = CGFloat(view.frame.height)
        sandyBackgroundWidth = CGFloat(view.frame.width)
        sandyBackGround.frame = CGRect(x: (view.frame.width / 2) - sandyBackgroundWidth / 2, y: (view.frame.height / 2) - sandyBackgroundHeight / 2, width: sandyBackgroundWidth, height: sandyBackgroundHeight)
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func hostButtonAction(_ sender: Any) {
        hostOrNot = true
    }
    @IBAction func joinButtonAction(_ sender: Any) {
        hostOrNot = false
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

