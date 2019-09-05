//
//  AWSResponse.swift
//  AWS3A-iOS
//
//  Created by Mark Evans on 9/5/19.
//  Copyright © 2019 3Advance LLC. All rights reserved.
//

import Foundation

public struct AWSResponse: Codable {
    public var authenticationResult: AuthenticationResult?
    public var session: String?
    public var userConfirmed: Bool?

    enum CodingKeys: String, CodingKey {
        case authenticationResult = "AuthenticationResult"
        case session = "Session"
        case userConfirmed = "UserConfirmed"
    }
}

public struct AuthenticationResult: Codable {
    public var accessToken: String?
    public var idToken: String?
    public var refreshToken: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "AccessToken"
        case idToken = "IdToken"
        case refreshToken = "RefreshToken"
    }
}

public extension AWSResponse {
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
