//
//  GADBannerView.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/5/26.
//

import SwiftUI
import GoogleMobileAds

struct ADBannerView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController =
            UIViewController.getLastPresentedViewController()
        let request = GADRequest()
        bannerView.load(request)
        return bannerView
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {
    }
    
    typealias UIViewType = GADBannerView
}
