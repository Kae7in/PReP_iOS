//
//  ImageViewController.swift
//  PReP
//
//  Created by Kaelin D Hooper on 7/27/15.
//  Copyright (c) 2015 Kaelin Hooper. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    var image: UIImage!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.setImageView()
    }
    
    
    /* Initializes and sets frame/other properties of the UIImageView that will contain
       the image that we want to display for interacting with (zooming and moving) */
    func setImageView() {
        
        // Set the frame
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(origin: CGPoint(x: 0, y: self.navigationController!.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height), size:image.size)
        scrollView.addSubview(imageView)  // Add it as a subview to the scrollView
        
        // Sets the content size of the scrollView (this is how a user can scroll
        // around when the image is bigger than the screen size)
        scrollView.contentSize = image.size
        
        // Don't actually know that the double tap works...
        var doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapRecognizer)
        
        // Calculate and set the minimum zoom scale, 'minimumZoomScale,' of the scrollView
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight);
        scrollView.minimumZoomScale = minScale;
        
        // Set the maximum zoom scale, 'maximumZoomScale,' of the scrollView
        scrollView.maximumZoomScale = 10.0
        scrollView.zoomScale = minScale;  // Start the photo zoomed all the way out
        
        centerScrollViewContents()
    }
    
    
    /* UIScrollViewDelegate method that returns the UIView that should be used
       for scrolling. In this case, it's the UIImageView, 'imageView,' that we
       placed in the storyboard. */
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    /* Ensures that the frame of the 'imageView' in the 'scrollView' is positioned correctly,
       even as the user is in the middle of zooming */
    func centerScrollViewContents() {
        let centerPoint: CGPoint = CGPoint(x: self.scrollView.bounds.midX, y: self.scrollView.bounds.midY)
        var viewFrame: CGRect = imageView.frame
        var contentOffset: CGPoint = self.scrollView.contentOffset
        
        var x: CGFloat = centerPoint.x - viewFrame.size.width / CGFloat(2.0)
        var y: CGFloat = centerPoint.y - viewFrame.size.height / CGFloat(2.0)
        
        if x < 0 {
            contentOffset.x = -x
            viewFrame.origin.x = CGFloat(0.0)
        } else {
            viewFrame.origin.x = x
        }
        
        if y < 0 {
            contentOffset.y = -y
            viewFrame.origin.y = CGFloat(0.0)
        } else {
            viewFrame.origin.y = CGFloat(0.0)
        }
        
        imageView.frame = viewFrame
        scrollView.contentOffset = contentOffset
    }
    
    
    /* Method designated as the target of a UITapGesture double-tap;
       May not work; Not important enough to worry about */
    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        let pointInView = recognizer.locationInView(imageView)
        
        var newZoomScale = scrollView.zoomScale * 1.5
        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
        
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRectMake(x, y, w, h);
        
        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }
    
    
    /* UIScrollViewDelegate method that fires off when the user is attemping to
       zoom on the scrollView (e.g. spread two fingers apart or bring them close together.
    
       In this case, it manages constantly centering the content as it is being zoomed. */
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
