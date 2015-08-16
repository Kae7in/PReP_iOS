//
//  ModalViewController.swift
//  PReP
//
//  Created by Kaelin D Hooper on 7/15/15.
//  Copyright (c) 2015 Kaelin Hooper. All rights reserved.
//

import UIKit

class PresetViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    var subBlurView:UIVisualEffectView = UIVisualEffectView()
    var completionHandler: ((Void) -> Void)?
    var presetStrings:[String] = []
    var chosenItem: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        presetStrings = getPresets()
        self.view.layer.cornerRadius = CGFloat(8.0)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setScrollViewProperties()
        createForm()
    }
    
    
    /* Set content properties for scrollView inside popover */
    func setScrollViewProperties() {
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: CGFloat(presetStrings.count) * CGFloat(70.0))
        self.automaticallyAdjustsScrollViewInsets = false
        self.scrollView.contentInset = UIEdgeInsetsZero
        self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero
        self.scrollView.contentOffset = CGPointMake(0.0, 0.0)
        self.scrollView.delegate = self
    }
    
    
    /*  */
    func addDismissButton() {
        let dismissButton: UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        dismissButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        dismissButton.tintColor = UIColor.whiteColor()
        dismissButton.titleLabel!.font = UIFont(name: "Avenir", size: 20)
        dismissButton.setTitle("Dismiss", forState: UIControlState.Normal)
        dismissButton.addTarget(self, action: "dismiss:", forControlEvents: UIControlEvents.TouchUpInside)
        self.scrollView.addSubview(dismissButton)
        
        self.view.addConstraint(NSLayoutConstraint(item: dismissButton,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: CGFloat(1.0),
            constant: CGFloat(0.0)))
        
        var a = NSNumber(double: 3.0)
        var b = NSNumber(double: 4.0)
        
        //        self.view.addConstraint(NSLayoutConstraint.constraintsWithVisualFormat("V:[dismissButton]-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["dismissButton" as NSObject : dismissButton as AnyObject]))
    }
    
    func createForm() {
        var yPos = CGFloat(50.0)
        for presetString: String in presetStrings {
            yPos = buttonGenerator(presetString, placeholder: presetString, yPos: yPos)
        }
    }
    
    func getPresets() -> [String] {
        // TODO: Create JSON objects that represent real presets
        return ["Default", "Preset 1", "Preset 2", "Preset 3", "Preset 4", "Preset 5", "Preset 6", "Preset 7", "Preset 8", "Preset 9", "Preset 10"]
    }
    
    func dismiss(sender: AnyObject) {
        self.completionHandler!()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func buttonGenerator(labelText: String, placeholder: String, yPos: CGFloat) -> CGFloat {
        let sidePadding = CGFloat(60.0)
        
        // UIButton
        var button: UIButton = UIButton(frame: CGRectIntegral(CGRect(x: sidePadding / CGFloat(2.0),
            y: yPos + CGFloat(30.0),
            width: self.view.frame.width - sidePadding,
            height: 30)))
        var attributes: NSDictionary = NSDictionary(dictionary: [NSFontAttributeName:UIFont(name: "Avenir-Book", size: 15)!,
            NSForegroundColorAttributeName:UIColor(red: 145.0/255.0, green: 145.0/255.0, blue: 145.0/255.0, alpha: 1.0)])
        button.titleLabel?.attributedText = NSAttributedString(string: placeholder, attributes: attributes as [NSObject : AnyObject])
        button.titleLabel?.font = UIFont(name: "Avenir-Book", size: CGFloat(15.0))
        button.setTitle(labelText, forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        var bottomTitleLabelBorder: CALayer = CALayer()
        bottomTitleLabelBorder.frame = CGRect(x: 0,
            y: button.frame.height + 2,
            width: button.frame.width,
            height: CGFloat(1.0))
        bottomTitleLabelBorder.backgroundColor = UIColor(red: 29.0/255.0, green: 29.0/255.0, blue: 38.0/255.0, alpha: 0.1).CGColor
        button.clipsToBounds = false
        button.addTarget(self, action: "presetButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        button.layer.addSublayer(bottomTitleLabelBorder)
        button.layer.setValue(bottomTitleLabelBorder, forKey: "bottomBorderLayer")
        scrollView.addSubview(button)
        
        return button.frame.maxY
    }
    
    
    func presetButtonAction(sender: UIButton!) {
        // TODO: Pass selection to detail view that contains this popover
        
        dismiss(sender)
    }
    
    
}