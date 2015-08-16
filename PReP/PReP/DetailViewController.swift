//
//  DetailViewController.swift
//  PReP
//
//  Created by Kaelin D Hooper on 7/24/15.
//  Copyright (c) 2015 Kaelin Hooper. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    /* public */
    var image: UIImage?
    var color: UIColor!
    
    /* private */
    @IBOutlet weak var scrollView: UIScrollView!
//    private var previousScrollViewYOffset: CGFloat = CGFloat(0.0)
    // TODO: var data: NSJSONSerialization or NSDictionary? - this will receive JSON data from ShoeboxViewController
    private var imageView: UIImageView!
    private var titleTextField: UITextField!
    private var groupTextField: UITextField!
    private var categoryTextField: UITextField!
    private var amountTextField: UITextField!
    private var descriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getImageToBeUsed()
        setNavBarTitle()
        setScrollViewProperties()
        createForm()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForKeyboardNotifications()  // Set self as observer using NSNotificationCenter
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)  // Remove self as observer
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /* Set the header image for this detail view.
       Should be the same one as shown in the Shoebox when the item was selected. */
    func getImageToBeUsed() {
        // TODO: Get image from network call
        image = UIImage(named: "paper")
    }
    
    
    /* Set the content size and other properties of the scroll view,
       in prep for placing the custom form as a subview inside of it. */
    func setScrollViewProperties() {
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: CGFloat(800.0))
        self.automaticallyAdjustsScrollViewInsets = false
        self.scrollView.contentInset = UIEdgeInsetsZero
        self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero
        self.scrollView.contentOffset = CGPointMake(0.0, 0.0)
        self.scrollView.delegate = self
    }
    
    
    /* Initialize and the set the frame for the UIImageView that will
       be the header for this detail view. */
    func setFormImageView(asSubviewOf thisView: UIView) {
        if self.imageView == nil {
            self.imageView = UIImageView(frame: CGRect(x: 0,
                y: 0,
                width: thisView.bounds.width,
                height: thisView.bounds.height / CGFloat(2.5)))
            self.imageView?.image = self.image != nil ? self.image! : UIImage(named: "pwclogo")
            self.imageView?.contentMode = self.image != nil ? UIViewContentMode.ScaleAspectFill : UIViewContentMode.ScaleAspectFit
            self.imageView?.clipsToBounds = true
            self.imageView?.layer.borderWidth = CGFloat(1.0)
            self.imageView?.layer.borderColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0).CGColor
            self.imageView?.userInteractionEnabled = true
            
            var singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imageTapped")
            singleTap.numberOfTapsRequired = 1
            self.imageView.addGestureRecognizer(singleTap)
            
            thisView.addSubview(self.imageView)
        }
    }
    
    
    /* Action function for UITapGestureRecognizer on 'imageView' */
    func imageTapped() {
        self.performSegueWithIdentifier("segueToImageView", sender: self)
    }
    
    
    /* Prepare for segue to full image view in ImageViewController */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationVC: ImageViewController = segue.destinationViewController as! ImageViewController
        destinationVC.image = image  // This is why 'image' is a global variable
    }
    
    
    /* Manages creating the custom form of UITextFields and UITextViews */
    func createForm() {
        self.setFormImageView(asSubviewOf: self.scrollView)
        
        var maxY = self.textFieldGenerator("title", placeholder: "Title", yPos: self.imageView!.frame.maxY)
        maxY = self.textFieldGenerator("group", placeholder: "Group", yPos: maxY + CGFloat(10.0))
        maxY = self.textFieldGenerator("category", placeholder: "Category", yPos: maxY + CGFloat(10.0))
        maxY = self.textFieldGenerator("amount", placeholder: "20,000", yPos: maxY + CGFloat(10.0))
        self.textViewGenerator("description", placeholder: "blah", yPos: maxY + CGFloat(10.0))
    }
    
    
    /* Generates a custom UITextField */
    func textFieldGenerator(labelText: String, placeholder: String, yPos: CGFloat) -> CGFloat {
        let sidePadding = CGFloat(60.0)
        
        // Title initialization and frame/other property setting
        var titleLabel: UILabel = UILabel(frame: CGRectIntegral(CGRect(x: sidePadding / CGFloat(2.0),
            y: yPos + CGFloat(15.0),
            width: self.view.frame.width - sidePadding,
            height: 30)))
        titleLabel.font = UIFont(name: "Avenir-Book", size: CGFloat(13.0))
        titleLabel.text = labelText.uppercaseString
        titleLabel.textColor = UIColor(red: 145.0/255.0, green: 145.0/255.0, blue: 145.0/255.0, alpha: 1.0)
        self.scrollView.addSubview(titleLabel)  // Add it as a subview to the scrollView
        
        // UITextField initialization and frame/other property setting
        self.titleTextField = UITextField(frame: CGRect(x: titleLabel.frame.minX,
            y: titleLabel.frame.maxY,
            width: titleLabel.frame.width,
            height: titleLabel.frame.height))
        var attributes: NSDictionary = NSDictionary(dictionary: [NSFontAttributeName:UIFont(name: "Avenir-Book", size: 15)!,
            NSForegroundColorAttributeName:UIColor(red: 145.0/255.0, green: 145.0/255.0, blue: 145.0/255.0, alpha: 1.0)])
        self.titleTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes as [NSObject : AnyObject])
        self.titleTextField.font = UIFont(name: "Avenir-Book", size: CGFloat(15.0))
        var bottomTitleLabelBorder: CALayer = CALayer()
        bottomTitleLabelBorder.frame = CGRect(x: 0,
            y: self.titleTextField.frame.height + 2,
            width: self.titleTextField.frame.width,
            height: CGFloat(1.0))
        bottomTitleLabelBorder.backgroundColor = UIColor(red: 29.0/255.0, green: 29.0/255.0, blue: 38.0/255.0, alpha: 0.1).CGColor
        self.titleTextField.clipsToBounds = false
        self.titleTextField.layer.addSublayer(bottomTitleLabelBorder)
        self.titleTextField.layer.setValue(bottomTitleLabelBorder, forKey: "bottomBorderLayer")
        self.titleTextField.returnKeyType = UIReturnKeyType.Done
        self.titleTextField.delegate = self
        self.scrollView.addSubview(self.titleTextField)  // Add it as a subview to the scrollView
        
        return self.titleTextField.frame.maxY
    }
    
    
    /* UITextFieldDelegate method that fires off when 'Done' has been tapped */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    /* UITextFieldDelegate method that fires off when the text field has begun editing */
    func textFieldDidBeginEditing(textField: UITextField) {
        self.scrollView.frame = CGRect(x: self.scrollView.frame.origin.x,
            y: self.scrollView.frame.origin.y,
            width: self.scrollView.frame.width,
            height: self.scrollView.frame.height - 215 + 50)
        var bottomTitleLabelBorder: CALayer = textField.layer.valueForKey("bottomBorderLayer") as! CALayer
        bottomTitleLabelBorder.backgroundColor = self.color.CGColor
    }
    
    
    /* UITextFieldDelegate method that fires off when the text field has ended editing */
    func textFieldDidEndEditing(textField: UITextField) {
        self.scrollView.frame = CGRect(x: self.scrollView.frame.origin.x,
            y: self.scrollView.frame.origin.y,
            width: self.scrollView.frame.width,
            height: self.scrollView.frame.height + 215 - 50)
        var bottomTitleLabelBorder: CALayer = textField.layer.valueForKey("bottomBorderLayer") as! CALayer
        bottomTitleLabelBorder.backgroundColor = UIColor(red: 29.0/255.0, green: 29.0/255.0, blue: 38.0/255.0, alpha: 0.1).CGColor
    }
    
    
    /* Generates a custom UITextView */
    func textViewGenerator(labelText: String, placeholder: String, yPos: CGFloat) -> CGFloat {
        let sidePadding = CGFloat(60.0)
        
        // Title initialization and frame/other property setting
        var titleLabel: UILabel = UILabel(frame: CGRectIntegral(CGRect(x: sidePadding / CGFloat(2.0),
            y: yPos + CGFloat(15.0),
            width: self.view.frame.width - sidePadding,
            height: 30)))
        titleLabel.font = UIFont(name: "Avenir-Book", size: CGFloat(13.0))
        titleLabel.text = labelText.uppercaseString
        titleLabel.textColor = UIColor(red: 145.0/255.0, green: 145.0/255.0, blue: 145.0/255.0, alpha: 1.0)
        self.scrollView.addSubview(titleLabel)  // Add it as a subview to the scrollView
        
        // UITextView initialization and frame/other property setting
        self.descriptionTextView = UITextView(frame: CGRect(x: -1,
            y: titleLabel.frame.maxY,
            width: self.view.frame.width + 1,
            height: CGFloat(200.0)))
        var attributes: NSDictionary = NSDictionary(dictionary: [NSFontAttributeName:UIFont(name: "Avenir-Book", size: 15)!,
            NSForegroundColorAttributeName:UIColor(red: 145.0/255.0, green: 145.0/255.0, blue: 145.0/255.0, alpha: 1.0)])
        self.descriptionTextView.font = UIFont(name: "Avenir-Book", size: CGFloat(15.0))
        self.descriptionTextView.layer.borderWidth = CGFloat(1.0)
        self.descriptionTextView.layer.borderColor = UIColor(red: 29.0/255.0, green: 29.0/255.0, blue: 38.0/255.0, alpha: 0.1).CGColor
        self.descriptionTextView.returnKeyType = UIReturnKeyType.Done
        self.descriptionTextView.delegate = self
        self.scrollView.addSubview(self.descriptionTextView)  // Add it as a subview the scrollView
        
        return self.descriptionTextView.frame.maxY
    }
    
    
    /* UITextViewDelegate method that fires off when the text view has begun editing */
    func textViewDidBeginEditing(textView: UITextView) {
        textView.layer.borderColor = self.color.CGColor
    }
    
    
    /* UITextViewDelegate method that fires off when the text view has ended editing */
    func textViewDidEndEditing(textView: UITextView) {
        textView.layer.borderColor = UIColor(red: 29.0/255.0, green: 29.0/255.0, blue: 38.0/255.0, alpha: 0.1).CGColor
    }
    
    
    // Call this method somewhere in your view controller setup code.
    func registerForKeyboardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,
            selector: "keyboardWillBeShown:",
            name: UIKeyboardWillShowNotification,
            object: nil)
        notificationCenter.addObserver(self,
            selector: "keyboardWillBeHidden:",
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    /* Called when the UIKeyboardDidShowNotification is sent */
    func keyboardWillBeShown(sender: NSNotification) {
        let info: NSDictionary = sender.userInfo!
        let value: NSValue = info.valueForKey(UIKeyboardFrameBeginUserInfoKey) as! NSValue
        let keyboardSize: CGSize = value.CGRectValue().size
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect: CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        let activeTextFieldRect: CGRect? = self.descriptionTextView?.frame
        let activeTextFieldOrigin: CGPoint? = activeTextFieldRect?.origin
        if (!CGRectContainsPoint(aRect, activeTextFieldOrigin!)) {
            scrollView.scrollRectToVisible(activeTextFieldRect!, animated:true)
        }
    }
    
    /* Called when the UIKeyboardWillHideNotification is sent */
    func keyboardWillBeHidden(sender: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    /* Create custom UINavigationBar title in order to employ typical "PReP" font and styling */
    func setNavBarTitle() {
        // Create custom UILabel to go in place of default titleView
        var titleLabel: UILabel = UILabel()
        var attributes: NSDictionary = NSDictionary(dictionary: [NSFontAttributeName:UIFont(name: "Georgia-BoldItalic", size: 25)!,
            NSForegroundColorAttributeName:UIColor.blackColor()])
        titleLabel.attributedText = NSAttributedString(string: "PReP", attributes: attributes as [NSObject : AnyObject])
        titleLabel.sizeToFit()
        
        // Set titleView to new custom UILabel
        navigationItem.titleView = titleLabel
        
        // Make the label a little wider to account for italicized font (otherwise the 'P' in PRe'P' gets cutoff a bit
        navigationItem.titleView!.frame = CGRectMake(navigationItem.titleView!.frame.minX , navigationItem.titleView!.frame.minY , navigationItem.titleView!.frame.width + CGFloat(5), navigationItem.titleView!.frame.height)
    }
    
    /* The code below aims to collapse the top nav bar on scrolling up.
        However, success in getting the "Back" navigation bar button item
        to fade to a transparency of 1.0 has wavered. If this can be
        accomplished, all that's left is to 1) move the rest of the view
        up a distance of (top nav bar height + status bar height) and 2) create
        a dismiss method that can initiate pulling the nav bar back down
        in case the user segues to a different view while the nav bar is
        still hiddne. */
    
//        func scrollViewDidScroll(scrollView: UIScrollView) {
//            var frame: CGRect = self.navigationController!.navigationBar.frame
//            var size: CGFloat = frame.height - 21
//            var framePercentageHidden: CGFloat = ((20 - frame.origin.y) / (frame.height - 1))
//            var scrollOffset: CGFloat = scrollView.contentOffset.y
//            var scrollDiff: CGFloat = scrollOffset - self.previousScrollViewYOffset
//            var scrollHeight: CGFloat = scrollView.frame.size.height
//            var scrollContentSizeHeight: CGFloat = scrollView.contentSize.height + scrollView.contentInset.bottom;
//    
//            if scrollOffset <= -scrollView.contentInset.top {
//                frame.origin.y = 20
//            } else if (scrollOffset + scrollHeight) >= scrollContentSizeHeight {
//                frame.origin.y = -size
//            } else {
//                frame.origin.y = min(20, max(-size, frame.origin.y - scrollDiff))
//            }
//    
//            self.navigationController!.navigationBar.frame = frame
//            self.updateBarButtonItems(1 - framePercentageHidden)
//            self.previousScrollViewYOffset = scrollOffset
//        }
//    
//        func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//            self.stoppedScrolling()
//        }
//    
//        func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//            if !decelerate {
//                self.stoppedScrolling()
//            }
//        }
//    
//        func stoppedScrolling() {
//            var frame: CGRect = self.navigationController!.navigationBar.frame
//            if frame.origin.y < 20 {
//                self.animateNavBarTo(-(frame.height - 21))
//            }
//        }
//    
//        func updateBarButtonItems(alpha: CGFloat) {
//            println("items: \(self.navigationItem.leftBarButtonItems)")
//            println("item: \(self.navigationItem.leftBarButtonItem)")
//    
//            self.navigationItem.titleView?.alpha = alpha
//    //        UIBarButtonItem.appearance().tintColor = UIBarButtonItem.appearance().tintColor.colorWithAlphaComponent(alpha)
//    //        self.navigationController!.navigationBar.barTintColor = self.navigationController!.navigationBar.barTintColor?.colorWithAlphaComponent(alpha)
//            self.navigationController!.navigationBar.tintColor = self.navigationController!.navigationBar.tintColor.colorWithAlphaComponent(alpha)
//        }
//    
//        func animateNavBarTo(y: CGFloat) {
//            UIView.animateWithDuration(NSTimeInterval(0.2), animations: { () -> Void in
//                var frame: CGRect = self.navigationController!.navigationBar.frame
//                var alpha: CGFloat = frame.origin.y >= y ? 0 : 1
//                frame.origin.y = y
//                self.navigationController!.navigationBar.frame = frame
//                self.updateBarButtonItems(alpha)
//            })
//        }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}