//
//  ViewController.swift
//  Example
//
//  Created by Mark Evans on Sep 5, 2019.
//  Copyright © 2019 3Advance LLC. All rights reserved.
//

import UIKit
import AWS3A

// MARK: ViewController

class ViewController: UIViewController {

    // MARK: Properties

    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "🚀\nAWS3A\nExample"
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()

    var testUsername = ""
    var testPassword = ""
    var testPhoneNumber = ""
    var testAccessToken = ""
    var testRefreshToken = ""
    var testCode = ""
    var testSession = ""
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

//        AWSService.shared.confirmUser(email: self.testUsername, newPassword: self.testPassword, session: self.testSession) { (success, error) in }
//        AWSService.shared.loginUser(email: self.testUsername, password: self.testPassword) { (success, error) in }
//        AWSService.shared.confirmRegisterUser(email: self.testUsername, code: self.testCode) { (success, error) in }
//        AWSService.shared.registerUser(email: self.testUsername, password: self.testPassword) { (success, error) in }
//        AWSService.shared.refreshToken(refreshToken: self.testRefreshToken) { (success, error) in }
//        AWSService.shared.validateUser(accessToken: self.testAccessToken) { (success, error) in }
//        AWSService.shared.logout(accessToken: self.testAccessToken) { (success, error) in }
//        AWSService.shared.resetPassword(username: self.testUsername) { (success, error) in }
//        AWSService.shared.resetConfirmPassword(username: self.testUsername, password: self.testPassword, code: self.testCode) { (success, error) in }
//        AWSService.shared.requestSMSCode(phone: self.testPhoneNumber) { (success, error) in }
//        AWSService.shared.confirmSMSCode(phone: self.testPhoneNumber, code: self.testCode, session: self.testSession) { (success, error) in }
    }

    override func loadView() {
        self.view = self.label
    }
}
