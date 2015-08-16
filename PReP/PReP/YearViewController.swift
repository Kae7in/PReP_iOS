//
//  ModalViewController.swift
//  PReP
//
//  Created by Kaelin D Hooper on 7/15/15.
//  Copyright (c) 2015 Kaelin Hooper. All rights reserved.
//

import UIKit

class YearViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    var subBlurView:UIVisualEffectView = UIVisualEffectView()
    var completionHandler: ((Void) -> Void)?
    var yearStrings:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        yearStrings = getYears()
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
    
    
    /* Sets the content properties of the scrollView inside the popover */
    func setScrollViewProperties() {
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: CGFloat(yearStrings.count) * CGFloat(100.0))
        self.automaticallyAdjustsScrollViewInsets = false
        self.scrollView.contentInset = UIEdgeInsetsZero
        self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero
        self.scrollView.contentOffset = CGPointMake(0.0, 0.0)
        self.scrollView.delegate = self
    }
    
    
    /* Manages the creation of rows of year buttons */
    func createForm() {
        var yPos = CGFloat(10.0)
        for yearString: String in yearStrings {
            yPos = buttonGenerator(yearString, placeholder: yearString, yPos: yPos)
        }
        addDismissButton()
    }
    
    
    /* Returns a String array of the possible years that can be chosen */
    func getYears() -> [String] {
        // TODO: Make this an actual network call that fetches the real years
        return ["2015", "2016", "2017"]
    }
    
    
    /* Dismisses the view of the popover controller entirely */
    func dismiss(sender: AnyObject) {
        self.completionHandler!()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /* Generates a UIButton and adds it to the scrollView in the popover.
       
       'titleString' to be placed as a title of UIButton
       'placeholder' to be placed in text field before editing occurs
       'yPos' to define the minY of the frame of the entire button/title mix */
    func buttonGenerator(titleString: String, placeholder: String, yPos: CGFloat) -> CGFloat {
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
        button.setTitle(titleString, forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        var bottomTitleLabelBorder: CALayer = CALayer()
        bottomTitleLabelBorder.frame = CGRect(x: 0,
            y: button.frame.height + 2,
            width: button.frame.width,
            height: CGFloat(1.0))
        bottomTitleLabelBorder.backgroundColor = UIColor(red: 29.0/255.0, green: 29.0/255.0, blue: 38.0/255.0, alpha: 0.1).CGColor
        button.clipsToBounds = false
        button.addTarget(self, action: "yearButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        button.layer.addSublayer(bottomTitleLabelBorder)
        button.layer.setValue(bottomTitleLabelBorder, forKey: "bottomBorderLayer")
        scrollView.addSubview(button)
        
        return button.frame.maxY
    }
    
    
    /* Adds a UIButton that dismisses the popover */
    func addDismissButton() {
        let sidePadding = CGFloat(60.0)
        
        // Initialize UIButton and set its frame and other properties
        var button: UIButton = UIButton(frame: CGRectIntegral(CGRect(x: sidePadding / CGFloat(2.0),
            y: scrollView.frame.size.height - CGFloat (50.0),
            width: self.view.frame.width - sidePadding,
            height: 30)))
        var attributes: NSDictionary = NSDictionary(dictionary: [NSFontAttributeName:UIFont(name: "Avenir-Book", size: 15)!,
            NSForegroundColorAttributeName:UIColor(red: 145.0/255.0, green: 145.0/255.0, blue: 145.0/255.0, alpha: 1.0)])
        button.titleLabel?.attributedText = NSAttributedString(string: "Close", attributes: attributes as [NSObject : AnyObject])
        button.titleLabel?.font = UIFont(name: "Avenir-Book", size: CGFloat(15.0))
        button.setTitle("Close", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: "dismiss:", forControlEvents: UIControlEvents.TouchUpInside)  // Determines which method it calls when tapped
        
        scrollView.addSubview(button)  // Add button as subview to the scrollView
    }
    
    
    func yearButtonAction(sender: UIButton!) {
        // TODO: Pass selection back to previous view
        /* let superVC = view.superview as! ShoeboxViewController
           superVC.yearResult = sender.titleLabel.text */
        
        dismiss(sender)
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}