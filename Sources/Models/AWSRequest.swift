//
//  AWSRequest.swift
//  AWS3A-iOS
//
//  Created by Mark Evans on 9/5/19.
//  Copyright © 2019 3Advance LLC. All rights reserved.
//

import Foundation

struct AWSRequest: Codable {
    var authParameters: AuthParameters?
    var authFlow: String?
    var clientId: String?
    var password: String?
    var username: String?
    var confirmationCode: String?
    var forceAliasCreation: Bool?
    var session: String?
    var userAttributes: [UserAttributes]?
    var userContextData: UserContextData?
    var challengeName: String?
    var challengeResponses: ChallengeResponses?
    var accessToken: String?
    var previousPassword: String?
    var proposedPassword: String?

    enum CodingKeys: String, CodingKey {
        case authParameters = "AuthParameters"
        case authFlow = "AuthFlow"
        case clientId = "ClientId"
        case password = "Password"
        case username = "Username"
        case confirmationCode = "ConfirmationCode"
        case forceAliasCreation = "ForceAliasCreation"
        case session = "Session"
        case userAttributes = "UserAttributes"
        case userContextData = "UserContextData"
        case challengeName = "ChallengeName"
        case challengeResponses = "ChallengeResponses"
        case accessToken = "AccessToken"
        case previousPassword = "PreviousPassword"
        case proposedPassword = "ProposedPassword"
    }
}

struct AuthParameters: Codable {
    var username: String?
    var password: String?
    var answer: String?
    var refreshToken: String?
    var deviceKey: String?

    enum CodingKeys: String, CodingKey {
        case username = "USERNAME"
        case password = "PASSWORD"
        case answer = "ANSWER"
        case refreshToken = "REFRESH_TOKEN"
        case deviceKey = "DEVICE_KEY"
    }
}

public struct UserAttributes: Codable {
    var name: String?
    var value: String?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case value = "Value"
    }
}

struct ChallengeResponses: Codable {
    var username: String?
    var newPassword: String?
    var answer: String?

    enum CodingKeys: String, CodingKey {
        case username = "USERNAME"
        case newPassword = "NEW_PASSWORD"
        case answer = "ANSWER"
    }
}

struct UserContextData: Codable {
    var encodedData: String?

    enum CodingKeys: String, CodingKey {
        case encodedData = "EncodedData"
    }
}

extension AWSRequest {
    static var defaultDomain = "https://cognito-idp.us-east-1.amazonaws.com"

    var json: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try encoder.encode(self)
            return String(data: jsonData, encoding: .utf8) ?? "{}"
        }
        catch {
            return "{}"
        }
    }

    var data: Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try encoder.encode(self)
            return jsonData
        }
        catch {
            return nil
        }
    }
}

extension AWSRequest {
    static func requestRegisterUser(clientId: String, email: String, password: String) -> URLRequest {
        let url = URL(string: AWSRequest.defaultDomain)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/x-amz-json-1.1", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("AWSCognitoIdentityProviderService.SignUp", forHTTPHeaderField: "X-Amz-Target")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = AWSRequest.registerUserBody(clientId: clientId, username: email, password: password)
        return urlRequest
    }

    static func requestConfirmRegisterUser(clientId: String, email: String, code: String) -> URLRequest {
        let url = URL(string: AWSRequest.defaultDomain)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/x-amz-json-1.1", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("AWSCognitoIdentityProviderService.ConfirmSignUp", forHTTPHeaderField: "X-Amz-Target")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = AWSRequest.confirmRegisterUserBody(clientId: clientId, username: email, code: code)
        return urlRequest
    }

    static func requestLoginUser(clientId: String, email: String, password: String) -> URLRequest {
        let url = URL(string: AWSRequest.defaultDomain)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/x-amz-json-1.1", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("AWSCognitoIdentityProviderService.InitiateAuth", forHTTPHeaderField: "X-Amz-Target")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = AWSRequest.loginUserBody(clientId: clientId, username: email, password: password)
        return urlRequest
    }

    static func requestConfirmUser(clientId: String, email: String, newPassword: String, session: String) -> URLRequest {
        let url = URL(string: AWSRequest.defaultDomain)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/x-amz-json-1.1", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("AWSCognitoIdentityProviderService.RespondToAuthChallenge", forHTTPHeaderField: "X-Amz-Target")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = AWSRequest.confirmUserBody(clientId: clientId, username: email, newPassword: newPassword, session: session)
        return urlRequest
    }

    static func requestRefreshToken(clientId: String, refreshToken: String) -> URLRequest {
        let url = URL(string: AWSRequest.defaultDomain)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/x-amz-json-1.1", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("AWSCognitoIdentityProviderService.InitiateAuth", forHTTPHeaderField: "X-Amz-Target")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = AWSRequest.refreshTokenBody(clientId: clientId, refreshToken: refreshToken)
        return urlRequest
    }

    static func requestLogout(clientId: String, accessToken: String) -> URLRequest {
        let url = URL(string: AWSRequest.defaultDomain)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/x-amz-json-1.1", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("AWSCognitoIdentityProviderService.GlobalSignOut", forHTTPHeaderField: "X-Amz-Target")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = AWSRequest.logoutBody(clientId: clientId, accessToken: accessToken)
        return urlRequest
    }

    static func requestValidateUser(clientId: String, accessToken: String) -> URLRequest {
        let url = URL(string: AWSRequest.defaultDomain)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/x-amz-json-1.1", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("AWSCognitoIdentityProviderService.GetUser", forHTTPHeaderField: "X-Amz-Target")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = AWSRequest.validateUserBody(clientId: clientId, accessToken: accessToken)
        return urlRequest
    }

    static func requestChangePassword(clientId: String, accessToken: String, previousPassword: String, proposedPassword: String) -> URLRequest {
        let url = URL(string: AWSRequest.defaultDomain)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/x-amz-json-1.1", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("AWSCognitoIdentityProviderService.ChangePassword", forHTTPHeaderField: "X-Amz-Target")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = AWSRequest.changePasswordBody(clientId: clientId, accessToken: accessToken, previousPassword: previousPassword, proposedPassword: proposedPassword)
        return urlRequest
    }

    static func requestResetPassword(clientId: String, username: String) -> URLRequest {
        let url = URL(string: AWSRequest.defaultDomain)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/x-amz-json-1.1", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("AWSCognitoIdentityProviderService.ForgotPassword", forHTTPHeaderField: "X-Amz-Target")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = AWSRequest.resetPasswordBody(clientId: clientId, username: username)
        return urlRequest
    }

    static func requestResetConfirmPassword(clientId: String, username: String, password: String, code: String) -> URLRequest {
        let url = URL(string: AWSRequest.defaultDomain)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/x-amz-json-1.1", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("AWSCognitoIdentityProviderService.ConfirmForgotPassword", forHTTPHeaderField: "X-Amz-Target")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = AWSRequest.resetConfirmPasswordBody(clientId: clientId, username: username, password: password, code: code)
        return urlRequest
    }

    static func requestSMSCode(clientId: String, phoneNumber: String) -> URLRequest {
        let url = URL(string: AWSRequest.defaultDomain)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/x-amz-json-1.1", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("AWSCognitoIdentityProviderService.InitiateAuth", forHTTPHeaderField: "X-Amz-Target")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = AWSRequest.requestSMSCodeBody(clientId: clientId, phoneNumber: phoneNumber)
        return urlRequest
    }

    static func requestConfirmSMSCode(clientId: String, phoneNumber: String, code: String, session: String) -> URLRequest {
        let url = URL(string: AWSRequest.defaultDomain)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/x-amz-json-1.1", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("AWSCognitoIdentityProviderService.RespondToAuthChallenge", forHTTPHeaderField: "X-Amz-Target")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = AWSRequest.requestConfirmSMSBody(clientId: clientId, phoneNumber: phoneNumber, code: code, session: session)
        return urlRequest
    }
}

extension AWSRequest {
    static private func refreshTokenBody(clientId: String, refreshToken: String) -> Data? {
        let request = AWSRequest(authParameters: AuthParameters(username: nil, password: nil, answer: nil, refreshToken: refreshToken, deviceKey: nil), authFlow: "REFRESH_TOKEN_AUTH", clientId: clientId, password: nil, username: nil, confirmationCode: nil, forceAliasCreation: nil, session: nil, userAttributes: nil, userContextData: nil, challengeName: nil, challengeResponses: nil, accessToken: nil, previousPassword: nil, proposedPassword: nil)
        return request.data
    }

    static private func loginUserBody(clientId: String, username: String, password: String) -> Data? {
        let request = AWSRequest(authParameters: AuthParameters(username: username, password: password, answer: nil, refreshToken: nil, deviceKey: nil), authFlow: "USER_PASSWORD_AUTH", clientId: clientId, password: nil, username: nil, confirmationCode: nil, forceAliasCreation: nil, session: nil, userAttributes: nil, userContextData: nil, challengeName: nil, challengeResponses: nil, accessToken: nil, previousPassword: nil, proposedPassword: nil)
        return request.data
    }

    static private func confirmUserBody(clientId: String, username: String, newPassword: String, session: String) -> Data? {
        let request = AWSRequest(authParameters: nil, authFlow: nil, clientId: clientId, password: nil, username: nil, confirmationCode: nil, forceAliasCreation: nil, session: session, userAttributes: nil, userContextData: nil, challengeName: "NEW_PASSWORD_REQUIRED", challengeResponses: ChallengeResponses(username: username, newPassword: newPassword, answer: nil), accessToken: nil, previousPassword: nil, proposedPassword: nil)
        return request.data
    }

    static private func registerUserBody(clientId: String, username: String, password: String) -> Data? {
        let request = AWSRequest(authParameters: nil, authFlow: nil, clientId: clientId, password: password, username: username, confirmationCode: nil, forceAliasCreation: nil, session: nil, userAttributes: [UserAttributes(name: "email", value: username)], userContextData: nil, challengeName: nil, challengeResponses: nil, accessToken: nil, previousPassword: nil, proposedPassword: nil)
        return request.data
    }

    static private func confirmRegisterUserBody(clientId: String, username: String, code: String) -> Data? {
        let request = AWSRequest(authParameters: nil, authFlow: nil, clientId: clientId, password: nil, username: username, confirmationCode: code, forceAliasCreation: true, session: nil, userAttributes: [UserAttributes(name: "email", value: username)], userContextData: nil, challengeName: nil, challengeResponses: nil, accessToken: nil, previousPassword: nil, proposedPassword: nil)
        return request.data
    }

    static private func logoutBody(clientId: String, accessToken: String) -> Data? {
        let request = AWSRequest(authParameters: nil, authFlow: nil, clientId: clientId, password: nil, username: nil, confirmationCode: nil, forceAliasCreation: nil, session: nil, userAttributes: nil, userContextData: nil, challengeName: nil, challengeResponses: nil, accessToken: accessToken, previousPassword: nil, proposedPassword: nil)
        return request.data
    }

    static private func validateUserBody(clientId: String, accessToken: String) -> Data? {
        let request = AWSRequest(authParameters: nil, authFlow: nil, clientId: clientId, password: nil, username: nil, confirmationCode: nil, forceAliasCreation: nil, session: nil, userAttributes: nil, userContextData: nil, challengeName: nil, challengeResponses: nil, accessToken: accessToken, previousPassword: nil, proposedPassword: nil)
        return request.data
    }

    static private func changePasswordBody(clientId: String, accessToken: String, previousPassword: String, proposedPassword: String) -> Data? {
        let request = AWSRequest(authParameters: nil, authFlow: nil, clientId: clientId, password: nil, username: nil, confirmationCode: nil, forceAliasCreation: nil, session: nil, userAttributes: nil, userContextData: nil, challengeName: nil, challengeResponses: nil, accessToken: accessToken, previousPassword: previousPassword, proposedPassword: proposedPassword)
        return request.data
    }

    static private func resetPasswordBody(clientId: String, username: String) -> Data? {
        let request = AWSRequest(authParameters: nil, authFlow: nil, clientId: clientId, password: nil, username: username, confirmationCode: nil, forceAliasCreation: nil, session: nil, userAttributes: nil, userContextData: nil, challengeName: nil, challengeResponses: nil, accessToken: nil, previousPassword: nil, proposedPassword: nil)
        return request.data
    }

    static private func resetConfirmPasswordBody(clientId: String, username: String, password: String, code: String) -> Data? {
        let request = AWSRequest(authParameters: nil, authFlow: nil, clientId: clientId, password: password, username: username, confirmationCode: code, forceAliasCreation: nil, session: nil, userAttributes: nil, userContextData: nil, challengeName: nil, challengeResponses: nil, accessToken: nil, previousPassword: nil, proposedPassword: nil)
        return request.data
    }

    static private func requestSMSCodeBody(clientId: String, phoneNumber: String) -> Data? {
        let request = AWSRequest(authParameters: AuthParameters(username: phoneNumber, password: nil, answer: nil, refreshToken: nil, deviceKey: nil), authFlow: "CUSTOM_AUTH", clientId: clientId, password: nil, username: nil, confirmationCode: nil, forceAliasCreation: nil, session: nil, userAttributes: nil, userContextData: nil, challengeName: nil, challengeResponses: nil, accessToken: nil, previousPassword: nil, proposedPassword: nil)
        return request.data
    }

    static private func requestConfirmSMSBody(clientId: String, phoneNumber: String, code: String, session: String) -> Data? {
        let request = AWSRequest(authParameters: nil, authFlow: nil, clientId: clientId, password: nil, username: nil, confirmationCode: nil, forceAliasCreation: nil, session: session, userAttributes: nil, userContextData: nil, challengeName: "CUSTOM_CHALLENGE", challengeResponses: ChallengeResponses(username: phoneNumber, newPassword: nil, answer: code), accessToken: nil, previousPassword: nil, proposedPassword: nil)
        return request.data
    }
}

extension Int {
    var isValid: Bool {
        return self >= 200 && self < 300
    }
}

extension String {
    var phoneDigits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }

    var formattedNumber: String {
        var phoneNumber = self.phoneDigits
        let mask = "XXX-XXX-XXXX"
        switch phoneNumber.count {
        case 11:
            phoneNumber.removeFirst()
        case 12:
            phoneNumber.removeFirst()
            phoneNumber.removeFirst()
        default:
            print("")
        }
        if phoneNumber.count > 10 {
            return ""
        }
        var result = ""
        var index = phoneNumber.startIndex
        mask.forEach({
            if index != phoneNumber.endIndex {
                if $0 == "X" {
                    result.append(phoneNumber[index])
                    index = phoneNumber.index(after: index)
                }
                else {
                    result.append($0)
                }
            }
        })
        return result
    }

    public func toPhoneNumber() -> String {
        return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
}
