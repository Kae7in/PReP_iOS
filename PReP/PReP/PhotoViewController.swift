//
//  PhotoViewController.swift
//  PReP
//
//  Created by Kaelin Hooper on 7/6/15.
//  Copyright (c) 2015 Kaelin Hooper. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var selectPhotoButton: UIButton!
    var settings: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var picker: UIImagePickerController = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavBarTitle()
        
        // This keeps the UIImagePickerController from crashing the app,
        // in case it's running in a simulator instead of a real device
        if (!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            var myAlertView: UIAlertView = UIAlertView(title: "Error", message: "Device has no camera", delegate: nil, cancelButtonTitle: "OK")
        }
        
        // Check if openCameraOnStart has been set.
        // Uses NSUserDefaults as 'settings' (global variable)
        if let openCameraOnStart = settings.objectForKey("openCameraOnStart") as? Bool {
            if openCameraOnStart {
                takePhoto()
            }
        }
        
        picker.delegate = self
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    /* Reponds to 'Take Photo' button press */
    @IBAction func takePhotoButtonAction(sender: UIButton) {
        takePhoto()
    }
    
    
    /* Responds to 'Select Photo' button press */
    @IBAction func selectPhotoButtonAction(sender: UIButton) {
        selectPhoto()
    }
    
    
    /* Presents a UIImagePickerController with Photo Library as source */
    func takePhoto() {
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    
    /* Presents a UIImagePickerController with Camera Library as source */
    func selectPhoto() {
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    
    /* UIImagePickerControllerDelegate method that fires off when the user chooses to user a particular photo */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        // Save the image chosen to this view controller (in this case, present it via the imageView)
        if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = chosenImage
            self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        }
        
        // Dismiss the UIImagePickerController, with a completion handler
        picker.dismissViewControllerAnimated(true, completion: {() -> Void in
            // TODO: WAT DO NOW?
            self.performSegueWithIdentifier("segueToEditItem", sender: self);
        })
    }
    
    
    /* UIImagePickerControllerDelegate method that responds to the user canceling
       on a UIImagePickerController */
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

