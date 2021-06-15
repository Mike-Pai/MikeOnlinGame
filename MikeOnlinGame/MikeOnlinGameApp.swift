//
//  MikeOnlinGameApp.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/4/14.
//

import SwiftUI
import Firebase

@main
struct MikeOnlinGameApp: App {
    @UIApplicationDelegateAdaptor(AppDelegateFirebase.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            PageController( image: UIImage(systemName: "photo")!)
        }
    }
}
