//
//  ItemCell.swift
//  PReP
//
//  Created by Kaelin D Hooper on 7/20/15.
//  Copyright (c) 2015 Kaelin Hooper. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    /* footer stuff */
    private var imageView: UIImageView
    private var footerView: UIView
    private var footerHeight: CGFloat = CGFloat(1.0)
    var editBorderColor: CGColor = UIColor.clearColor().CGColor
    var deletionMode = false
    
    /* label stuff */
    private var titleLabel: UILabel?
    private var categoryLabel: UILabel?
    private var amountLabel: UILabel?
    private var dateLabel: UILabel?
    private var titleString: String = "TITLE"
    private var categoryString: String = "CATEGORY"
    private var amountString: String = "AMOUNT"
    private var dateString: String = "DATE"
    
    
    override init(frame: CGRect) {
        // Create imageView
        imageView = UIImageView(frame: frame)  // Initialize UIImageView to span entire frame of this cell
        
        // Create footerView
        footerHeight = CGFloat(frame.height / 4)  // Calculate footerView height based on cell height
        footerView = UIView(frame: CGRectMake(0, frame.height - footerHeight, frame.width, footerHeight))
        
        /* INITIALIZATION MUST OCCUR AT THIS POINT */
        super.init(frame: frame)
        
        // Create UILabels
        createUILabelViews()
        
        // Create edit border
        layer.borderWidth = CGFloat(2.0)
        layer.borderColor = self.editBorderColor
        deletionMode = false
        
        // Add the footerView as a subview to this cell's contentView
        contentView.addSubview(footerView)
    }
    
    
    /* Sets the background image of this cell */
    func setBackgroundImage(withImage: UIImage) {
        imageView.image = withImage
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundView = imageView
    }
    
    
    /* Initializes the UILabels and adds them as subviews to the footeView */
    private func createUILabelViews() {
        // titleLabel
        titleLabel = UILabel(frame: CGRectIntegral(CGRect(x: CGFloat(3.0),
            y: CGFloat(0.0),
            width: footerView.frame.width - CGFloat(3.0),
            height: footerView.frame.height / CGFloat(2.0))))
        titleLabel!.textAlignment = NSTextAlignment.Center
        footerView.addSubview(titleLabel!)
        
        // categoryLabel
        categoryLabel = UILabel(frame: CGRectIntegral(CGRect(x: CGFloat(4.0),
            y: footerView.frame.height - (footerView.frame.height / CGFloat(2.6)),
            width: footerView.frame.width / CGFloat(2.0),
            height: footerView.frame.height / CGFloat(2.3))))
        categoryLabel!.textAlignment = NSTextAlignment.Left
        footerView.addSubview(categoryLabel!)
        
        // amountLabel
        amountLabel = UILabel(frame: CGRectIntegral(CGRect(x: footerView.frame.width / CGFloat(2.0),
            y: footerView.frame.height - (footerView.frame.height / CGFloat(2.6)),
            width: (footerView.frame.width / CGFloat(2.0)) - CGFloat(3.0),
            height: footerView.frame.height / CGFloat(2.3))))
        amountLabel!.textAlignment = NSTextAlignment.Right
        footerView.addSubview(amountLabel!)
        
        // dateLabel
        dateLabel = UILabel(frame: CGRectIntegral(CGRect(x: CGFloat(0.0),
            y: footerView.bounds.maxY,
            width: footerView.frame.width,
            height: footerView.frame.height / CGFloat(2.0))))
        dateLabel!.textAlignment = NSTextAlignment.Center
        footerView.addSubview(dateLabel!)
    }
    
    
    func setTitleLabel(string str: String) {
        titleString = str
        updateLabelTexts()
    }
    
    func setCategoryLabel(string str: String) {
        categoryString = str
        updateLabelTexts()
    }
    
    func setAmountLabel(string str: String) {
        amountString = str
        updateLabelTexts()
    }
    
    func setDateLabel(string str: String) {
        dateString = str
        updateLabelTexts()
    }
    
    func setFooterColor(color: UIColor) {
        footerView.backgroundColor = color
    }
    
    
    /* Updates the text for all labels by setting the font and size according to the
       screen size of the current device */
    private func updateLabelTexts() {
        let screenRect: CGRect = UIScreen.mainScreen().bounds
        var titleFontSize = screenRect.width / 20
        var subtitleFontSize = screenRect.width / 27
        
        var currentDeviceName: String = UIDevice.currentDevice().model
        if DeviceIdentifier.iPad() {
            // The current device is an iPad
            titleFontSize = screenRect.width / 35
            subtitleFontSize = screenRect.width / 45
        } else if DeviceIdentifier.iPhone() {
            // The current device is an iPhone
            titleFontSize = screenRect.width / 18
            subtitleFontSize = screenRect.width / 24
        } else {
            // The current device is a ...wait... What the heck did you buy? A windows phone??
            titleFontSize = screenRect.width / 18
            subtitleFontSize = screenRect.width / 24
        }

        // titleLabel
        var attributes: NSDictionary = NSDictionary(dictionary: [NSFontAttributeName:UIFont(name: "Avenir-Book", size: titleFontSize)!,
            NSForegroundColorAttributeName:UIColor.whiteColor()])
        self.titleLabel!.attributedText = NSAttributedString(string: titleString, attributes: attributes as [NSObject: AnyObject])
        titleLabel!.adjustsFontSizeToFitWidth = true
        
        // categoryLabel
        attributes = NSDictionary(dictionary: [NSFontAttributeName:UIFont(name: "Avenir-Book", size: subtitleFontSize)!,
            NSForegroundColorAttributeName:UIColor.whiteColor()])
        self.categoryLabel!.attributedText = NSAttributedString(string: categoryString, attributes: attributes as [NSObject: AnyObject])
        categoryLabel!.adjustsFontSizeToFitWidth = true
        
        // amountLabel
        attributes = NSDictionary(dictionary: [NSFontAttributeName:UIFont(name: "Avenir-Book", size: subtitleFontSize)!,
            NSForegroundColorAttributeName:UIColor.whiteColor()])
        self.amountLabel!.attributedText = NSAttributedString(string: amountString, attributes: attributes as [NSObject: AnyObject])
        amountLabel!.adjustsFontSizeToFitWidth = true
        
        // dateLabel
        attributes = NSDictionary(dictionary: [NSFontAttributeName:UIFont(name: "Avenir-Book", size: subtitleFontSize)!,
            NSForegroundColorAttributeName:UIColor.blackColor()])
        self.dateLabel!.attributedText = NSAttributedString(string: dateString, attributes: attributes as [NSObject: AnyObject])
        dateLabel!.adjustsFontSizeToFitWidth = true
    }
    
    func update() {
        updateLabelTexts()
        
        // TODO: Get the edit border to show up and work
        if (selected) {
            layer.borderColor = editBorderColor
        } else {
            layer.borderColor = UIColor.clearColor().CGColor
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
