//
//  AppDelegate.swift
//  PReP
//
//  Created by Kaelin Hooper on 7/6/15.
//  Copyright (c) 2015 Kaelin Hooper. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        /* Set UITabBar appearance */
        let redThemeColor = UIColor(red: 224/256, green: 48/256, blue: 30/256, alpha: 1)
        UITabBar.appearance().tintColor = redThemeColor
        UITabBar.appearance().barTintColor = UIColor.whiteColor()
        
        /* Set UINavigationBar appearance */
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        UINavigationBar.appearance().tintColor = UIColor(red: 224/256, green: 48/256, blue: 30/256, alpha: 1)
        let attributes = [NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 18)!,
            NSForegroundColorAttributeName:redThemeColor]
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, forState: UIControlState.Normal)
        
        let tabBar: UITabBarController = self.window?.rootViewController as! UITabBarController
        tabBar.delegate = self
        
        /* Register App Default Settings
        
           This ensures that when the app is first downloaded and opened
           that the settings are initialized to some value other than nil,
           when appropriate. These will be permanently overriden as the user
           changes the settings themselves. */
        var settings = NSMutableDictionary(dictionary: [
            "swipeBetweenGroups": "true",
            "openCameraOnStart": "false",
            "defaultYear": "2014",
            "defaultSelectedGroup": "0",
        ])
        NSUserDefaults.standardUserDefaults().registerDefaults(settings as [NSObject : AnyObject])
        NSUserDefaults.standardUserDefaults().synchronize()  // Permanently saves these settings
        
        /* Check settings to see if camera should be opened on start */
        if let openCameraOnStart = NSUserDefaults.standardUserDefaults().objectForKey("openCameraOnStart") as? Bool {
            if openCameraOnStart {
                // If so, open up to the camera tab first (upon view loading)
                let tabBar: UITabBarController = self.window?.rootViewController as! UITabBarController
                tabBar.selectedIndex = 1
            }
        }
        
        return true
    }
    
    
    /* If the user selects the shoebox tab, call its 'enforceSettings()' method so that the updated
       settings will be reflected, even the if user changes settings during the runtime of the app */
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if tabBarController.selectedIndex == 0 {
            let navigationVC: UINavigationController = viewController as! UINavigationController
            let shoeboxVC: ShoeboxViewController = navigationVC.childViewControllers.first as! ShoeboxViewController
            shoeboxVC.enforceSettings()
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

