//
//  AppDelegate.swift
//  Midi_Swift
//
//  Created by zhou on 15/11/20.
//  Copyright (c) 2015年 zhou. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var viewController : UIViewController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        self.setupViewControllers()
        self.window?.rootViewController = self.viewController
        self.window?.makeKeyAndVisible()
        
        return true
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
    
    func setupViewControllers()
    {
        let firstViewController = FirstViewController()
        var fistNaviController  = UINavigationController(rootViewController: firstViewController)
        
        let secondViewController = SecondViewController()
        var secondNaviController = UINavigationController(rootViewController: secondViewController)
        
        let tabBarController : RDVTabBarController = RDVTabBarController()
        tabBarController.viewControllers = [firstViewController,secondViewController]
        
        self.viewController = tabBarController
        
        self.customizeTabBarForController(tabBarController)
        
    }
    
    func customizeTabBarForController(tabBarController:RDVTabBarController){
        let finishedImage = UIImage(named: "tabbar_selected_background")
        let unfinishedImage = UIImage(named: "tabbar_normal_background")
        var tabBarItemImages = ["first","second","third"]
        
        for (i,item) in (tabBarController.tabBar.items).enumerate()
        {
            let sitem = item as! RDVTabBarItem
            item.setBackgroundSelectedImage(finishedImage, withUnselectedImage: unfinishedImage)
            let selectedImage = UIImage(named: "\(tabBarItemImages[i])_selected")
            let unselectedImage = UIImage(named: "\(tabBarItemImages[i])_normal")
            sitem.setFinishedSelectedImage(selectedImage, withFinishedUnselectedImage: unselectedImage)
        }
    }
    
    func customizeInterface(){
        let navigationBarApper = UINavigationBar.appearance()
        var backgroundImage: UIImage
        
        var texAttr = [:]
        
        if NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1{
            
        }
        
        backgroundImage = UIImage(named: "navigationbar_background_tall")!
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.clearColor()
        shadow.shadowOffset = CGSize.zero
        navigationBarApper.titleTextAttributes =
            [NSFontAttributeName:UIFont.boldSystemFontOfSize(18),
                NSForegroundColorAttributeName:UIColor.blackColor(),
                NSShadowAttributeName:shadow
        ]
        navigationBarApper.setBackgroundImage(backgroundImage, forBarMetrics: UIBarMetrics.Default)
    }


}

