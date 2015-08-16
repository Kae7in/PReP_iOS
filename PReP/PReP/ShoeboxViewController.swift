//
//  ShoeboxViewController.swift
//  PReP
//
//  Created by Kaelin Hooper on 7/9/15.
//  Copyright (c) 2015 Kaelin Hooper. All rights reserved.
//

import UIKit

/* UICollectionViewDelegateFlowLayout inherits from the needed UICollectionViewDelegate and UIScrollViewDelegate */
class ShoeboxViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var yearBarButton: UIBarButtonItem!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    var searchButton: UIButton = UIButton()
    var settings: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    private var scrollViewFrameSet = false
    private let NUMBER_OF_GROUPS = 4
    private var collectionViews: [UICollectionView?] = []
    // private var dataToSegueWith: TYPE - TODO: Will this be a JSONSerialization object or a dictionary?
    private var items: NSMutableArray = NSMutableArray()
    private var selectedCells: NSMutableArray = NSMutableArray()
    private var segmentedControl: HMSegmentedControl = HMSegmentedControl()
    private var searchTextField: SearchTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarTitle()
        addSegmentedControlBar()
        addSearchButton()
        enforceSettings()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // These actions MUST occur after the view's outlets and frame have been set (e.g. after the view has appeared)
        setScrollViewContentSize()
        loadPages()
    }
    
    
    /* Enforce default settings pertaining to this view controller (such as enabling/disabling
       swiping between groups) and enforce settings changed during runtime of app.
    
       This method gets called in two ways:
       1) When the view first loads
       2) By the AppDelegate when this tab is selected. */
    func enforceSettings() {
        if scrollView == nil {
            /* scrollView can be nil if the app opens on camera first
               This is because the appDelegate will call this method before
               viewDidLoad() and viewDidAppear() execute */
            return
        }
        
        // Check for "swipeBetweenGroups" setting in NSUserDefaults (defined as "settings" global)
        if let shouldAllowHorizontalScroll = settings.objectForKey("swipeBetweenGroups") as? Bool {
            scrollView.scrollEnabled = shouldAllowHorizontalScroll
        }
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        updateSegmentedControl()  // Attempt to update the segmented control bar
    }
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        dismissSearchBar()  // We want the search bar to go away when scrolling
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
        navigationItem.titleView!.frame = CGRectMake(navigationItem.titleView!.frame.minX , navigationItem.titleView!.frame.minY, navigationItem.titleView!.frame.width + CGFloat(5), navigationItem.titleView!.frame.height)
    }
    
    
    /* Initialize and place searchButton (global variable) to float over scrollView. */
    func addSearchButton() {
        
        // y-pos of search button in all states (selected and unselected) - can be modified
        let yPosition = navigationController!.navigationBar.frame.height + segmentedControl.frame.height + CGFloat(40.0)
        
        searchButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton  // Initialize searchButton
        searchButton.setImage(UIImage(named: "search"), forState: UIControlState.Normal)  // set the search icon as image
        searchButton.frame = CGRectMake(CGFloat(25.0), yPosition, CGFloat(50.0), CGFloat(50.0))  // set frame of button
        searchButton.userInteractionEnabled = true
        
        // Create blurView to place behind search icon
        let searchBlurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
        searchBlurView.frame = CGRect(x: searchButton.bounds.minX + CGFloat(5.0), y: searchButton.bounds.minY + CGFloat(5.0), width: searchButton.bounds.width - CGFloat(10.0), height: searchButton.bounds.height - CGFloat(10.0))
        searchBlurView.layer.cornerRadius = CGFloat(4.0)
        searchBlurView.clipsToBounds = false
        searchBlurView.userInteractionEnabled = true
        
        // Add blurview as subview to searchButton
        searchButton.addSubview(searchBlurView)
        
        // Add searchButton as subview to main view
        view.addSubview(searchButton)
        
        // This forces the search icon to be on top of the blur view
        searchButton.bringSubviewToFront(searchButton.imageView!)
        
        // Initialize and set properties of searchTextField
        if searchTextField == nil {
            searchTextField = SearchTextField(frame: searchButton.bounds)  // Define frame
            searchTextField.delegate = self
            searchTextField.backgroundColor = UIColor.clearColor()
            searchTextField.returnKeyType = UIReturnKeyType.Search
            searchTextField.userInteractionEnabled = true
            searchTextField.font = UIFont(name: "Avenir-Book", size: CGFloat(17.0))
            searchButton.addSubview(searchTextField)  // Add searchTextField as subview to searchButton
        }
    }
    
    
    /* UITextFieldDelegate method that fires off when the user taps on the search icon.
       This method is triggered when tapping the search icon because a UITextField (searchTextField) sits over
       the search button as a small transparent square. This is used to capture the tap, instead of the button, so
       that the text field doesn't have to be added and removed from the view. Also, this 
       allows for the possibility for adding a target function to the button to initiate
       a search or some other additional action - if the user taps on the search icon - AFTER the
       search field has become active (this is possible because the text field moves off to the
       right, no longer sitting over the searchButton). */
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        // Find the gray blur view (a subview of searchButton) that sits over
        // the inactive search icon so that we can make it transparent.
        var blurView: UIVisualEffectView!
        for view in searchButton.subviews {
            if view.isKindOfClass(UIVisualEffectView) {
                blurView = view as! UIVisualEffectView;
            }
        }
        
        // Fire off an animation that presents the search textField
        UIView.animateWithDuration(NSTimeInterval(0.2), animations: { () -> Void in
            // Set target frame (frame animation should end on)
            textField.frame = CGRect(x: textField.frame.origin.x + textField.frame.width,
                y: textField.frame.origin.y,
                width: self.view.bounds.width - (CGFloat(2.0) * CGFloat(self.searchButton.frame.minX)) - textField.frame.width,
                height: textField.frame.size.height)
            
            // Make the text field appear (transition from clearColor() to whiteColor())
            textField.backgroundColor = UIColor.whiteColor()
            
            // Set background color of the button to the current page's color
            self.searchButton.backgroundColor =  UIColor.colorBasedOnIndex(self.getCurrentPage()).colorWithAlphaComponent(CGFloat(0.8))
            
            // Make the gray blur view behind the button transparent
            blurView.alpha = 0
        })
        textField.placeholder = "Search"
        
        return true
    }
    
    
    /* UITextFieldDelegate method that fires off when the user hits the keyboard
       return button. It simply reverses the effects of textFieldShouldBeginEditing. */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        dismissSearchBar()
        
        return true
    }
    
    
    /* Reverses the effects of textFieldShouldBeginEditing, effectively collapsing the
       searchTextField back into a square that sits over the searchButton.
    
       Can also be called by other elements of the UI (such as the scollView) to ensure
       that the search field is dismissed upon navigating away. */
    func dismissSearchBar() {
        // Find the gray blur view (a subview of searchButton) that sits over
        // the active search icon so that we can make it visible again.
        if searchTextField.editing {
            var blurView: UIVisualEffectView!
            for view in searchButton.subviews {
                if view.isKindOfClass(UIVisualEffectView) {
                    blurView = view as! UIVisualEffectView;
                }
            }
            
            // Fire off an animation that dismisses the search textField
            UIView.animateWithDuration(NSTimeInterval(0.2), animations: { () -> Void in
                self.searchTextField.frame = self.searchButton.bounds  // Set target frame (frame animation should end on)
                self.searchTextField.backgroundColor = UIColor.clearColor()  // Make the textField transparent
                self.searchButton.backgroundColor = UIColor.clearColor()  // Make the searchButton transparent
                blurView.alpha = 1
            })
            searchTextField.text = ""
            searchTextField.placeholder = ""
            searchTextField.resignFirstResponder()  // This will dismiss the keyboard
        }
    }
    
    
    /* Get the current "page" (based on 'x' position) that the scrollView is on. */
    func getCurrentPage() -> Int {
        // Determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        return page
    }
    
    
    /* Update page control bar (aka segmentedControl) at top of screen such that it reflects
       which page the scrollView is currently on. */
    func updateSegmentedControl() {
        // First, get the number of the page that's currently visible
        let page = getCurrentPage()
        
        // Update the page control
        if (page < NUMBER_OF_GROUPS && page >= 0) {
            segmentedControl.setSelectedSegmentIndex(UInt(page), animated: true)
            segmentedControl.selectionIndicatorColor = UIColor.colorBasedOnIndex(getCurrentPage())
            segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName:UIColor.colorBasedOnIndex(getCurrentPage())]
        }
    }
    
    
    /* Initiates editing mode for collection view. */
    @IBAction func editButtonAction(sender: UIBarButtonItem) {
        if (editing) {
            editBarButton.title = "Edit"
            for cv in collectionViews {
                cv?.allowsMultipleSelection = false
            }
        } else {
            editBarButton.title = "Done"
            for cv in collectionViews {
                cv?.allowsMultipleSelection = true
            }
        }
        
        editing = !editing
    }
    
    
    /* UIViewControllerTransitioningDelegate method.
       This method handles presenting the year popover. 
       See 'PresentingViewController.swift for more info. */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentingAnimationController()
    }
    
    
    /* UIViewControllerTransitioningDelegate method.
       This method handles dismissing the year popover.
       See 'DismissingViewController.swift for more info. */
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissingAnimationController()
    }
    
    
    /* IBAction outlet for year bar button (fired off when year bar button
       is tapped). */
    @IBAction func yearBarButtonItemAction(sender: UIBarButtonItem) {
        dismissSearchBar()  // If search bar is active, dismiss it
        
        // Initialize popover
        let modalVC:YearViewController = storyboard!.instantiateViewControllerWithIdentifier("customYearModal") as! YearViewController
        
        // Set properties of popover
        modalVC.transitioningDelegate = self
        modalVC.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        // Create blur view to sit just behind the popover
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        tabBarController!.view.addSubview(blurView)
        blurView.frame = view.bounds
        
        // Pass a pointer of the blur view to the popover so that the popover's
        // completion handler can remove it.
        modalVC.subBlurView = blurView
        modalVC.completionHandler = {() -> Void in
            blurView.removeFromSuperview()
        }
        
        navigationController?.presentViewController(modalVC, animated: true, completion: nil)
    }
    
    
    /* Called in 'viewDidLoad()' to set the frame and other properties of the page control
       (aka 'segmentedControl').
    
       This segmented control bar is created using a handy Pod library called 'HMSegmentedControl'. */
    func addSegmentedControlBar() {
        // Initialize HMSegmentedControl
        segmentedControl = HMSegmentedControl(sectionTitles: ["Firm Items", "Income", "Deductions", "Payments"])
        
        // Set the frame
        segmentedControl.frame = CGRectMake(0, navigationController!.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height,
            view.frame.width, 40)
        
        // Set other visual properties
        segmentedControl.selectedSegmentIndex = 0  // Default selected index
        segmentedControl.titleTextAttributes = [NSFontAttributeName:UIFont(name: "Avenir-Book", size: 13)!]
        segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName:UIColor.colorBasedOnIndex(getCurrentPage())]
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
        blurView.frame = segmentedControl.bounds
        segmentedControl.addSubview(blurView)  // This will make the background blurred
        segmentedControl.backgroundColor = UIColor.clearColor()  // We don't need color; we have a blur view
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        segmentedControl.selectionIndicatorColor = UIColor.colorBasedOnIndex(getCurrentPage())
        segmentedControl.selectionIndicatorHeight = CGFloat(3)
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe
        
        // Add completion handler that fires off when index on the segmentedControl changes
        var completionHandler:IndexChangeBlock = { (index:Int) -> Void in
            self.dismissSearchBar()  // If the search bar is active, dismiss it
            let scrollViewSize = self.scrollView.frame.size
            self.scrollView.scrollRectToVisible(CGRectMake(scrollViewSize.width * CGFloat(index), 0, scrollViewSize.width, scrollViewSize.height), animated: true)
        }
        segmentedControl.indexChangeBlock = completionHandler
        
        view.addSubview(segmentedControl)  // Add this baby to the main view
        segmentedControl.sendSubviewToBack(blurView)  // Ensures that the labels appear ABOVE the blur view
    }
    
    
    /* Set the content size of the scrollView (the view that multiple collection views
       will be placed in). */
    func setScrollViewContentSize() {
        
        scrollView.alwaysBounceVertical = false
        
        for _ in 0..<NUMBER_OF_GROUPS {
            collectionViews.append(nil)
        }
        
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(NUMBER_OF_GROUPS),
            height: pagesScrollViewSize.height)
        
        scrollViewFrameSet = true
    }
    
    
    /* Sets frame and initializes a new collection view at page 'page' */
    func loadPage(page: Int) {
        if page < 0 || page >= NUMBER_OF_GROUPS || !scrollViewFrameSet {
            // If it's outside the range of page indexes available to display
            // OR the scrollView's frame has not been set yet, then do nothing
            return
        }
        
        if let collectionView = collectionViews[page] {
            // Do nothing. A UICollectionView is already loaded at this page.
        } else {
            // Set the new collection view's frame
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            // Set layout for collection view
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()  // Layout type
            layout.sectionInset = UIEdgeInsets(top: 51, left: 16, bottom: 30, right: 16)  // Section layout
            layout.itemSize = itemSizeBasedOnScreenSize()  // Item layout
            
            // Initialize new collection view
            let newCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
            newCollectionView.dataSource = self
            newCollectionView.delegate = self
            newCollectionView.registerClass(ItemCell.self, forCellWithReuseIdentifier: "ItemCell")
            newCollectionView.backgroundColor = UIColor.clearColor()
            newCollectionView.showsHorizontalScrollIndicator = false
            newCollectionView.showsVerticalScrollIndicator = false
            
            scrollView.addSubview(newCollectionView)
            
            // Update our array of collection views
            collectionViews[page] = newCollectionView
        }
    }
    
    
    /* Calculates the size of the item based on the size of the screen
       of the device currently being used such that there are always
       2 items per row on iPhone and 4 items per row on iPad. This method
       ALWAYS returns a CGSize with a 4:3 ratio. */
    func itemSizeBasedOnScreenSize() -> CGSize {
        let screenWidth = view.bounds.size.width
        var targetItemWidth: CGFloat!
        var scalingFactor: CGFloat!
        
        if DeviceIdentifier.iPhone() {
            // We're an iPhone!
            targetItemWidth = (screenWidth / 2) - 25
            scalingFactor = targetItemWidth / 3
        } else if DeviceIdentifier.iPad() {
            // We're an iPad!
            targetItemWidth = (screenWidth / 4) - 25
            scalingFactor = targetItemWidth / 3
        } else {
            // Um... Did you really buy an iPod?
            targetItemWidth = (screenWidth / 2) - 25
            scalingFactor = targetItemWidth / 3
        }
        
        return CGSize(width: 3 * scalingFactor, height: 4 * scalingFactor)
    }
    
    
    /* Indicates the number of items that should exist in section 'section' for group 'getCurrentPage()' */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: Return integer based on number of items that will be in this section for this group
        return 14
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ItemCell = collectionView.dequeueReusableCellWithReuseIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        
        cell.setBackgroundImage(UIImage(named: "paper")!)  // TODO: Get image from network API
        setCellFooter(collectionView, cell: cell, withData: nil)  // TODO: Get data from network API
        
        return cell
    }
    
    
    /* Sets the properties (data and color) of the footer for ItemCell 'cell' */
    func setCellFooter(collectionView: UICollectionView, cell: ItemCell, withData: NSJSONSerialization?) {
        var colorIndex: Int? = nil
        var count = 0
        
        // Determine color for this collection view
        for cView in collectionViews {
            if collectionView === cView {
                colorIndex = count
                break
            }
            count += 1
        }
        
        // TODO: Acquire these strings from network API
        let titleString = "Example Title"  // Title
        let categoryString = "W-2"  // Category
        let amountString = "20,000"  // Amount
        let dateString = "8.7.2015"  // Date Uploaded
        
        cell.setTitleLabel(string: titleString)
        cell.setCategoryLabel(string: categoryString)
        cell.setAmountLabel(string: amountString)
        cell.setDateLabel(string: dateString)
        // Must use 'colorIndex' instead of getCurrentPage() because collectionViews have not been laid out yet
        cell.setFooterColor(UIColor.colorBasedOnIndex(colorIndex!).colorWithAlphaComponent(CGFloat(0.8)))
    }
    
    
    /* UICollectionViewDelegate method that responds to the user selecting an item in
       the visible collection view 'collectionViews[getCurrentPage()]' */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let collectionViewVisible: UICollectionView = collectionViews[getCurrentPage()]!
        let cell: ItemCell = collectionViewVisible.dequeueReusableCellWithReuseIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        
        if (editing) {
            // TODO: Get editing actually working...
            cell.editBorderColor = UIColor.colorBasedOnIndex(getCurrentPage()).CGColor  // Doesn't work
            cell.deletionMode = true  // Doesn't seem to help that it's not working
            cell.update()
            selectedCells.addObject(indexPath.item)
        } else {
            // TODO: Set dataToSegueWith (global variable) with the JSON of the tapped cell
            // e.g. dataToSegueWith = data[indexPath.section][indexPath.row]
            performSegueWithIdentifier("segueToDetailView", sender: self)
        }
        
    }
    
    
    /* UICollectionViewDelegate method that responds to the user DEselecting an item in
       the visible collection view 'collectionViews[getCurrentPage()]' */
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let collectionViewVisible: UICollectionView = collectionViews[getCurrentPage()]!
        let cell: ItemCell = collectionViewVisible.dequeueReusableCellWithReuseIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        
        selectedCells.removeObject(indexPath.item)
        
        cell.deletionMode = false  // Doesn't help with updating the cell's border color - why?
        cell.update()
    }
    
    
    /* Gets called when a 'performSegueWithIdentifier()' is called from the user selecting an item
       in the currently visible collection view */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        dismissSearchBar()  // We don't want that search bar active anymore, if it is
        
        if let destinationVC: DetailViewController = segue.destinationViewController as? DetailViewController {
            // Pass this section color to the detail view so that it can use it as a theme
            destinationVC.color = UIColor.colorBasedOnIndex(getCurrentPage())
            // TODO: destinationVC.data = dataToSegueWith - send JSON data to DetailViewController
        }
    }

    
    /* UICollectionViewDelegate method that specifies how much spacing should go above and below each item
       in section 'section' */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 30
    }
    
    
    /* Method that calls 'loadPage()' on all pages to be loaded.
    
       This method exists because we WERE lazy loading each of the pages
       based on the position that the user has scrolled in the horizontal
       direction. This functionality has been removed but can be reimplemented
       if desired. */
    func loadPages() {
        /* Lazy loading implementation was here */
        
        // No longer performing lazy loading; just load all pages on 'viewDidAppear()'
        for i in 0..<NUMBER_OF_GROUPS {
            loadPage(i)
        }
    }
    
}
