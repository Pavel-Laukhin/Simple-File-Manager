//
//  AppDelegate.swift
//  File Manager
//
//  Created by Павел on 21.12.2020.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let baseVC = BaseViewController(title: "Documents", at: "Documents")
        let navVC = UINavigationController(rootViewController: baseVC)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        return true
    }

}

