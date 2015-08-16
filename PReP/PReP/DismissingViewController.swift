//
//  DismissingAnimationController.swift
//  PReP
//
//  Created by Kaelin D Hooper on 7/15/15.
//  Copyright (c) 2015 Kaelin Hooper. All rights reserved.
//

import UIKit

class DismissingAnimationController: UIViewController, UIViewControllerAnimatedTransitioning {
    
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

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        var toView: UIView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!.view
        //        toView.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
        toView.userInteractionEnabled = true
        
        var fromView: UIView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!.view
        
        // POP animation that defines what position the popover will transition to (disappearing)
        var closeAnimation: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPLayerPositionY)
        closeAnimation.toValue = -fromView.layer.position.y
        closeAnimation.completionBlock = ({(anim: POPAnimation!, finished: Bool) in        transitionContext.completeTransition(true)
        })
        
        // POP animation that defines what scale the popover will transition to (scaling down in size)
        var scaleDownAnimation: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleDownAnimation.springBounciness = 20
        scaleDownAnimation.toValue = NSValue(CGPoint: CGPointMake(1.0, 1.0))
        
        // Add POP position and scale animations
        fromView.layer.pop_addAnimation(closeAnimation, forKey: "closeAnimation")
        fromView.layer.pop_addAnimation(scaleDownAnimation, forKey: "scaleDown")
    }
    
    
}