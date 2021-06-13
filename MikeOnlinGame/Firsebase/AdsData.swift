//
//  Data.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/4/14.
//

import Foundation
import GoogleMobileAds
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
}

class RewardedAdController: NSObject{
     private var ad: GADRewardedAd?
    
    func loadAd(){
        let request = GADRequest()
        
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: request) {ad, error in
            
            if let error = error {
                print(error)
                return
            }
            ad?.fullScreenContentDelegate = self
            self.ad = ad
        }
    }
    
    func showAd(){
        if let ad = ad,
           let controller = UIViewController.getLastPresentedViewController() {
            
            ad.present(fromRootViewController: controller) {
            }
            
        }
    }
}

extension RewardedAdController: GADFullScreenContentDelegate {
    
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print(#function)
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print(#function)
    }
    
    func ad(_ ad: GADFullScreenPresentingAd,
            didFailToPresentFullScreenContentWithError error: Error) {
        print(#function, error)
        
    }
    
}
