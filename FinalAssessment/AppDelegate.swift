//
//  AppDelegate.swift
//  FinalAssessment
//
//  Created by ALLAN CHAI on 21/12/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        
        observeNotification()
        
        UITabBar.appearance().barTintColor = UIColor.dodgerBlue
        UITabBar.appearance().tintColor = UIColor.white
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .selected)
        
        UINavigationBar.appearance().barTintColor = UIColor.dodgerBlue
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate {
   
        func observeNotification ()
        {
            NotificationCenter.default.addObserver(self, selector:#selector(handleUserLoginNotification(_:)), name: Notification.Name(rawValue: "AuthSuccessNotification"), object: nil)
            
            NotificationCenter.default.addObserver(self, selector:#selector(handleUserLoginNotification(_:)), name: Notification.Name(rawValue: "ExistLoggedInUserNotification"), object: nil)
            
             NotificationCenter.default.addObserver(self, selector:#selector(handleUserLogoutNotification(_:)), name: Notification.Name(rawValue: "UserLogoutNotification"), object: nil)
            
            
        }

    
    
    
    func handleUserLoginNotification (_ notification: Notification)
    {
        //this will only be called if user successfully login
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let tabBarController = storyBoard.instantiateViewController(withIdentifier: "NaviTabBarController")
        
        window?.rootViewController = tabBarController
    }
    
    func handleUserLogoutNotification(_ notification: Notification){
        //this will call when user logout successfully
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "acessNavigationController")
        
        window?.rootViewController = viewController
    }

    
    
}

