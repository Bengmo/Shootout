//
//  Color Detectioner.swift
//  High Noon: AR Western Duel
//
//  Created by Ben on 11/2/17.
//  Copyright © 2017 Ben Toth. All rights reserved.
//

import Foundation
import UIKit

var red = 0
var green = 0
var blue = 0


extension UIImage {
    
    func getPixelColor(pos: CGPoint) -> UIColor {
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        let r = CGFloat(data[pixelInfo]) // CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) // CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) // CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) // CGFloat(255.0)
        red = Int(b)
        green = Int(g)
        blue = Int(r)
        return UIColor(red: b, green: g, blue: r, alpha: a)
    }
    func resizeImage(image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width:image.size.width, height:1024))
        image.draw(in: CGRect(x:0, y:0, width:image.size.width, height:1024))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
