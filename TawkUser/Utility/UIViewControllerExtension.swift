//
//  UIViewControllerExtension.swift
//  TawkUser
//
//  Created by Sanjeev on 04/03/22.
//

import Foundation
import UIKit

fileprivate var spinnerView: UIView?
extension UIViewController {
    func showSpinner() {
        removeSpinner()
        spinnerView = UIView(frame: UIScreen.main.bounds)
        spinnerView?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = spinnerView?.center ?? self.view.center
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        spinnerView?.addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: spinnerView!.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: spinnerView!.centerXAnchor).isActive = true
        let vc = UIApplication.shared.topMostViewController()
        vc?.view.addSubview(spinnerView!)
    }
    func removeSpinner() {
        spinnerView?.removeFromSuperview()
        spinnerView = nil
    }
    
    func showNetworkError(message: String) {
        removeSpinner()
        spinnerView = UIView(frame: UIScreen.main.bounds)
        spinnerView?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let label = UILabel()
        label.center = spinnerView?.center ?? self.view.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = message
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut) {
            spinnerView?.addSubview(label)
            label.centerYAnchor.constraint(equalTo: spinnerView!.centerYAnchor).isActive = true
            label.centerXAnchor.constraint(equalTo: spinnerView!.centerXAnchor).isActive = true
            let vc = UIApplication.shared.topMostViewController()
            vc?.view.addSubview(spinnerView!)
        } completion: { _ in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                DispatchQueue.main.async {
                    self.removeSpinner()
                }
            }
        }
    }
    
    fileprivate func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return UIWindow.key!.rootViewController?.topMostViewController()
    }
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
