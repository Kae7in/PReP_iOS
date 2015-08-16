//
//  PresentingAnimationController.swift
//  PReP
//
//  Created by Kaelin D Hooper on 7/15/15.
//  Copyright (c) 2015 Kaelin Hooper. All rights reserved.
//

import UIKit

class PresentingAnimationController: UIViewController, UIViewControllerAnimatedTransitioning {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    
    /* Defines the animation that transitions the popover into the view */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        var fromView: UIView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!.view
        //        fromView.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
        fromView.userInteractionEnabled = false
        
        var toView: UIView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!.view
        toView.frame = CGRectMake(0, 0, CGRectGetWidth(transitionContext.containerView().bounds) - CGFloat(50.0), CGRectGetHeight(transitionContext.containerView().bounds) - CGFloat(170.0))
        
        var p: CGPoint = CGPointMake(transitionContext.containerView().center.x, -transitionContext.containerView().center.y)
        toView.center = p
        
        transitionContext.containerView().addSubview(toView)
        
        // POP animation that defines what position the popover will transition to (appearing)
        var positionAnimation: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        positionAnimation.toValue = transitionContext.containerView().center.y
        positionAnimation.springBounciness = 5
        positionAnimation.completionBlock = ({(anim: POPAnimation!, finished: Bool) -> Void in
            transitionContext.completeTransition(true)
        })
        
        // POP animation thaat defines what scale the popover will transition to (scaling up in size)
        var scaleAnimation: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnimation.springBounciness = 5
        scaleAnimation.fromValue = NSValue(CGPoint: CGPointMake(1.2, 1.4))
        
        // Add POP position and scale animations
        toView.layer.pop_addAnimation(positionAnimation, forKey: "positionAnimation")
        toView.layer.pop_addAnimation(scaleAnimation, forKey: "scaleAnimation")
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