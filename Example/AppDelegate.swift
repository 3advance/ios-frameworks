//
//  AppDelegate.swift
//  Example
//
//  Created by Mark Evans on Sep 5, 2019.
//  Copyright © 2019 3Advance LLC. All rights reserved.
//

import UIKit
import AWS3A

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    let testClientId = ""
    let testAppId = ""
    let testAccessKeyId = ""
    let testAccessSecret = ""

    var rootViewController: UIViewController {
        return ViewController()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AWSService.shared.enableLogs = true
        AWSService.shared.initialize(clientId: self.testClientId)
        AWSService.shared.initializePinpoint(appId: self.testAppId, accessKey: self.testAccessKeyId, accessSecret: self.testAccessSecret)
        self.window = .init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = self.rootViewController
        self.window?.makeKeyAndVisible()
        return true
    }
}
