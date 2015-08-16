//
//  SearchTextField.swift
//  PReP
//
//  Created by Kaelin D Hooper on 7/29/15.
//  Copyright (c) 2015 Kaelin Hooper. All rights reserved.
//

import UIKit

/* This class subclasses UITextField solely for the purpose of moving the
   placeholder text and typed text in the search bar to the right by 10 points. */
class SearchTextField: UITextField {
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, CGFloat(10.0), CGFloat(10.0))
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, CGFloat(10.0), CGFloat(10.0))
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, CGFloat(10.0), CGFloat(10.0))
    }
    
}
