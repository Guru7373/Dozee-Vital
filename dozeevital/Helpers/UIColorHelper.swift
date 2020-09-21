//
//  UIColorHelper.swift
//  dozeevital
//
//  Created by Guru Raj R on 19/09/20.
//

/*
 ***This Helper class provides an extension to UIColor to support HEX color and Dark Mode.***
*/

import UIKit

//MARK:- UIColor Hexstring support

extension UIColor {
    convenience init(hex: Int, alpha: Double = 1.0) {
        self.init(red: CGFloat((hex>>16)&0xFF)/255.0, green: CGFloat((hex>>8)&0xFF)/255.0, blue: CGFloat((hex)&0xFF)/255.0, alpha: CGFloat(255 * alpha) / 255)
    }
    
    convenience init(hexString: String, alpha: Double = 1.0) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(255 * alpha) / 255)
    }
}

//MARK:- Dark Mode support

extension UIColor {
    static func themeConvertor(dark: String, light: String) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { (trait) -> UIColor in
                return trait.userInterfaceStyle == .dark ? UIColor(hexString: dark) : UIColor(hexString: light)
            }
        } else {
            return UIColor(hexString: light)
        }
    }
}
