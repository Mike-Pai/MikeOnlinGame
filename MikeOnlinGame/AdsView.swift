//
//  AdsView.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/5/26.
//

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

struct AdsView: View {
    
    func requestTracking() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .notDetermined:
                break
            case .restricted:
                break
            case .denied:
                break
            case .authorized:
                break
            @unknown default:
                break
            }
        }
    }
    
    var body: some View {
        let rewordAdController = RewardedAdController()
        VStack{
            Spacer()
            Button(action: rewordAdController.loadAd, label: {
                Text("Load Ad")
            })
            
            Button(action: rewordAdController.showAd, label: {
                Text("ShowAd")
            })
            Spacer()
            ADBannerView()
                .frame(height: kGADAdSizeBanner.size.height)
        }
        .onAppear(perform: {
            requestTracking()
        })
        
    }
}

struct AdsView_Previews: PreviewProvider {
    static var previews: some View {
        AdsView()
    }
}
