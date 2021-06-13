//
//  UiviewController+Extention.swift
//  MikeOnlinGame
//
//  Created by 白謹瑜 on 2021/5/26.
//

import Foundation
import UIKit

extension UIViewController {
    static func getLastPresentedViewController() -> UIViewController? {
        let window = UIApplication.shared.windows.first {
            $0.isKeyWindow
        }
        var presentedViewController = window?.rootViewController
        while presentedViewController?.presentedViewController != nil {
            presentedViewController = presentedViewController?.presentedViewController
        }
        return presentedViewController
    }
}
