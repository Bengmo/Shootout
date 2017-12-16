//
//  ViewController4.swift
//  High Noon: AR Western Duel
//
//  Created by Ben on 11/2/17.
//  Copyright © 2017 Ben Toth. All rights reserved.
//

import UIKit



class ViewController4: UIViewController {
    @IBOutlet weak var youWinLabel: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var sandBackground: UIImageView!

    var restartButtonHeight = CGFloat()
    var restartButtonWidth = CGFloat()
    var homeButtonHeight = CGFloat()
    var homeButtonWidth = CGFloat()
    var youWinLabelHeight = CGFloat()
    var youWinLabelWidth = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sandBackground.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        restartButtonHeight = CGFloat(view.frame.height / 6)
        restartButtonWidth = CGFloat(view.frame.width / 2)
        restartButton.frame = CGRect(x: (view.frame.width / 2) - restartButtonWidth / 2 , y: (view.frame.height / 2) - restartButtonHeight / 2, width: restartButtonWidth, height: restartButtonHeight)
        youWinLabelHeight = CGFloat(view.frame.height / 4)
        youWinLabelWidth = CGFloat(view.frame.width / 1.2)
        youWinLabel.frame = CGRect(x: (view.frame.width / 2) - youWinLabelWidth / 2, y: (view.frame.height / 6) - youWinLabelHeight / 2, width: youWinLabelWidth, height: youWinLabelHeight)
        
        

        // Do any additional setup after loading the view.
    }
    

        


    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
