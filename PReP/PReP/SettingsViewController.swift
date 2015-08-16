//
//  SettingsVC.swift
//  PReP
//
//  Created by Kaelin Hooper on 7/6/15.
//  Copyright (c) 2015 Kaelin Hooper. All rights reserved.
//

import UIKit

class SettingsViewController: XLFormViewController, XLFormDescriptorDelegate {

    let settings = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setNavBarTitle()
        self.createForm()  // If this ever causes any major problems, you CAN move it viewDidAppear()
        self.setBackgroundProperties()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /* Set UINavigationBar title */
    func setNavBarTitle() {
        // Create custom UILabel to go in place of default titleView
        var titleLabel: UILabel = UILabel()
        var attributes: NSDictionary = NSDictionary(dictionary: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 20)!,
            NSForegroundColorAttributeName:UIColor(red: 100/256, green: 100/256, blue: 100/256, alpha: 1.0)])
        titleLabel.attributedText = NSAttributedString(string: "Settings", attributes: attributes as [NSObject : AnyObject])
        titleLabel.sizeToFit()
        
        // Set titleView to new custom UILabel
        self.navigationItem.titleView = titleLabel
    }
    
    
    /* Simply makes the background of the table view a light grey */
    func setBackgroundProperties() {
        self.tableView.backgroundColor = UIColor(red: 245/256, green: 245/256, blue: 245/256, alpha: 1.0)
    }
    
    
    /* Creates the settings form (UITableView) using XLForm Cocoapod library */
    func createForm() {
        var form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Settings") as XLFormDescriptor
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Default Settings") as XLFormSectionDescriptor
        form.addFormSection(section)
        
        // Camera Options
        row = XLFormRowDescriptor(tag: "openCameraOnStart", rowType: XLFormRowDescriptorTypeBooleanSwitch, title:"Open Camera On Start")
        row.value = settings.objectForKey("openCameraOnStart")
        // row.cellConfig.setObject(themeColor, forKey: "switchControl.onTintColor")  // Switches the tint color of the button!
        section.addFormRow(row)
        
        // Group Options
        row = XLFormRowDescriptor(tag: "swipeBetweenGroups", rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "Swipe Between Groups")
        //        row.cellConfig.setObject(themeColor, forKey: "switchControl.onTintColor")  // Switches the tint color of the button!
        row.value = settings.objectForKey("swipeBetweenGroups")
        section.addFormRow(row)
        
        // Default Year
        row = XLFormRowDescriptor(tag: "defaultYear", rowType: XLFormRowDescriptorTypeSelectorPush, title: "Default Year")
        row.value = settings.objectForKey("defaultYear")
        section.addFormRow(row)
        
        // Default Selected Group
        row = XLFormRowDescriptor(tag: "defaultSelectedGroup", rowType: XLFormRowDescriptorTypeSelectorPush, title: "Default Selected Group")
        row.value = settings.objectForKey("defaultSelectedGroup")
        section.addFormRow(row)
        
        /* App and PReP Info Section */
        section = XLFormSectionDescriptor.formSectionWithTitle("App Info") as XLFormSectionDescriptor
        form.addFormSection(section)
        
        // About PReP
        row = XLFormRowDescriptor(tag: "aboutPrep", rowType: XLFormRowDescriptorTypeButton, title: "About PReP")
        section.addFormRow(row)
        
        // Help
        row = XLFormRowDescriptor(tag: "help", rowType: XLFormRowDescriptorTypeButton, title: "Help")
        section.addFormRow(row)
        
        self.form = form  // Sets the global form in the XLFormViewController to the form we just initialized
        self.form.delegate = self  // This is so we can adhere to the XLFormDescriptorDelegate's requirements
        self.tableView.reloadData()  // Just do it. It protects against some weird problems that could come up in the future.
        // NOTE: tableView.reloadData() should also be called any time the table is updated after its already been loaded
    }
    
    override func formRowDescriptorValueHasChanged(formRow: XLFormRowDescriptor!, oldValue: AnyObject!, newValue: AnyObject!) {
        super.formRowDescriptorValueHasChanged(formRow, oldValue: oldValue, newValue: newValue)  // super implementation MUST be called
        if formRow.tag == "aboutPrep" {
            // TODO: Segue to about prep view
        } else if formRow.tag == "help" {
            // TODO: segue to help view
        } else {
            settings.setObject(newValue, forKey: "\(formRow.tag!)")
        }
        
        settings.synchronize()  // Permanently save the settings
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
