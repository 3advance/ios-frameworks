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
    }
}

struct AuthParameters: Codable {
    var username: String?
    var password: String?
    var refreshToken: String?
    var deviceKey: String?

    enum CodingKeys: String, CodingKey {
        case username = "USERNAME"
        case password = "PASSWORD"
        case refreshToken = "REFRESH_TOKEN"
        case deviceKey = "DEVICE_KEY"
    }
}

struct UserAttributes: Codable {
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

    enum CodingKeys: String, CodingKey {
        case username = "USERNAME"
        case newPassword = "NEW_PASSWORD"
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
}

extension AWSRequest {
    static private func refreshTokenBody(clientId: String, refreshToken: String) -> Data? {
        let request = AWSRequest(authParameters: AuthParameters(username: nil, password: nil, refreshToken: refreshToken, deviceKey: nil), authFlow: "REFRESH_TOKEN_AUTH", clientId: clientId, password: nil, username: nil, confirmationCode: nil, forceAliasCreation: nil, session: nil, userAttributes: nil, userContextData: nil, challengeName: nil, challengeResponses: nil)
        return request.data
    }

    static private func loginUserBody(clientId: String, username: String, password: String) -> Data? {
        let request = AWSRequest(authParameters: AuthParameters(username: username, password: password, refreshToken: nil, deviceKey: nil), authFlow: "USER_PASSWORD_AUTH", clientId: clientId, password: nil, username: nil, confirmationCode: nil, forceAliasCreation: nil, session: nil, userAttributes: nil, userContextData: nil, challengeName: nil, challengeResponses: nil)
        return request.data
    }

    static private func confirmUserBody(clientId: String, username: String, newPassword: String, session: String) -> Data? {
        let request = AWSRequest(authParameters: nil, authFlow: nil, clientId: clientId, password: nil, username: nil, confirmationCode: nil, forceAliasCreation: nil, session: session, userAttributes: nil, userContextData: nil, challengeName: "NEW_PASSWORD_REQUIRED", challengeResponses: ChallengeResponses(username: username, newPassword: newPassword))
        return request.data
    }

    static private func registerUserBody(clientId: String, username: String, password: String) -> Data? {
        let request = AWSRequest(authParameters: nil, authFlow: nil, clientId: clientId, password: password, username: username, confirmationCode: nil, forceAliasCreation: nil, session: nil, userAttributes: [UserAttributes(name: "email", value: username)], userContextData: nil, challengeName: nil, challengeResponses: nil)
        return request.data
    }

    static private func confirmRegisterUserBody(clientId: String, username: String, code: String) -> Data? {
        let request = AWSRequest(authParameters: nil, authFlow: nil, clientId: clientId, password: nil, username: username, confirmationCode: code, forceAliasCreation: true, session: nil, userAttributes: [UserAttributes(name: "email", value: username)], userContextData: nil, challengeName: nil, challengeResponses: nil)
        return request.data
    }
}

extension Int {
    var isValid: Bool {
        return self >= 200 && self < 300
    }
}
