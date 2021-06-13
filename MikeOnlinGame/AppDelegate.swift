//
//  AppDelegate.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/5/26.
//

import UIKit
import Firebase
import GoogleMobileAds

class AppDelegateFirebase: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
    
}
