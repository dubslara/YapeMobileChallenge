//
//  Swizzle.swift
//  YapeMobileChallenge
//
//  Created by Lara Dubs on 02/04/2023.
//

import Foundation
import UIKit

private let swizzling: (UIViewController.Type, Selector, Selector) -> Void = { forClass, originalSelector, swizzledSelector in
    if let originalMethod = class_getInstanceMethod(forClass, originalSelector), let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector) {
        let didAddMethod = class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        if didAddMethod {
            class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}

extension UIViewController {
    public static func swizzle() {
        let originalSelector1 = #selector(viewDidLoad)
        let swizzledSelector1 = #selector(swizzled_viewDidLoad)
        swizzling(UIViewController.self, originalSelector1, swizzledSelector1)
    }

    @objc open func swizzled_viewDidLoad() {
        configureNavigationAppearance()
        swizzled_viewDidLoad()
    }
}

extension UINavigationController {
    public static func swizzlePreferredStatusBar() {
        let originalSelector1 = #selector(getter: preferredStatusBarStyle)
        let swizzledSelector1 = #selector(getter: swizzled_preferredStatusBarStyle)
        swizzling(UINavigationController.self, originalSelector1, swizzledSelector1)
    }

    @objc open var swizzled_preferredStatusBarStyle: UIStatusBarStyle {
        topViewController?.preferredStatusBarStyle ?? .default
    }
}

extension UIViewController {
    func configureNavigationAppearance() {
        navigationItem.backButtonDisplayMode = .minimal
    }
}
