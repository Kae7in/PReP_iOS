//
//  PwCColor.swift
//  PReP
//
//  Created by Kaelin D Hooper on 7/29/15.
//  Copyright (c) 2015 Kaelin Hooper. All rights reserved.
//

import UIKit

/* This extension adds color functions to UIColor without having to subclass it. */
extension UIColor {
    class func pwcRedColor() -> UIColor {
        return UIColor(red: 224.0/255.0, green: 48.0/255.0, blue: 30.0/255.0, alpha: 1.0)
    }
    
    class func pwcYellowColor() -> UIColor {
        return UIColor(red: 243.0/255.0, green: 190.0/255.0, blue: 38.0/255.0, alpha: 1.0)
    }
    
    class func pwcRoseColor() -> UIColor {
        return UIColor(red: 230.0/255.0, green: 105.0/255.0, blue: 162.0/255.0, alpha: 1.0)
    }
    
    class func pwcOrangeColor() -> UIColor {
        return UIColor(red: 216.0/255.0, green: 86.0/255.0, blue: 4.0/255.0, alpha: 1.0)
    }
    
    class func pwcGreyColor() -> UIColor {
        return UIColor(red: 109.0/255.0, green: 110.0/255.0, blue: 113.0/255.0, alpha: 1.0)
    }
    
    /* Returns a color based on the page index, 'index,' given.
       More potential colors should probably be added in prep for more groups. */
    class func colorBasedOnIndex(index: Int) -> UIColor {
        var colors = [
            pwcRedColor(),
            pwcYellowColor(),
            pwcRoseColor(),
            pwcOrangeColor()]
        
        return colors[index % colors.count]
    }
}
