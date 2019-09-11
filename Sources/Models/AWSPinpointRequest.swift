//
//  AWSPinpointRequest.swift
//  AWS3A-iOS
//
//  Created by Mark Evans on 9/11/19.
//  Copyright © 2019 3Advance LLC. All rights reserved.
//

import Foundation

struct AWSPinpointRequest: Codable {
    var user: UserParams?
    var channelType: String?
    var address: String?
    var optOut: String?

    enum CodingKeys: String, CodingKey {
        case user = "User"
        case channelType = "ChannelType"
        case address = "Address"
        case optOut = "OptOut"
    }
}

public struct UserParams: Codable {
    var userId: String?

    enum CodingKeys: String, CodingKey {
        case userId = "UserId"
    }
}

extension AWSPinpointRequest {
    static var defaultDomain = "https://pinpoint.us-east-1.amazonaws.com"

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

extension AWSPinpointRequest {
    static func requestGetEndpoint(appId: String, userId: String) -> URLRequest {
        let prefix = "https://"
        let host = AWSPinpointRequest.defaultDomain.replacingOccurrences(of: prefix, with: "")
        let path = "/v1/apps/\(appId)/endpoints/\(userId)"
        let endpoint = prefix+host+path
        let url = URL(string: endpoint)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(host, forHTTPHeaderField: "Host")
        urlRequest.httpMethod = "GET"
        urlRequest.httpBody = nil
        return urlRequest
    }

    static func requestUpdateEndpoint(appId: String, userId: String, pushToken: String?, optOut: String?) -> URLRequest {
        let prefix = "https://"
        let host = AWSPinpointRequest.defaultDomain.replacingOccurrences(of: prefix, with: "")
        let path = "/v1/apps/\(appId)/endpoints/\(userId)"
        let endpoint = prefix+host+path
        let url = URL(string: endpoint)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(host, forHTTPHeaderField: "Host")
        urlRequest.httpMethod = "PUT"
        urlRequest.httpBody = AWSPinpointRequest.updateEndpoint(userId: userId, pushToken: pushToken, optOut: optOut)
        return urlRequest
    }
}

extension AWSPinpointRequest {
    static private func updateEndpoint(userId: String, pushToken: String?, optOut: String?) -> Data? {
        let request = AWSPinpointRequest(user: UserParams(userId: userId), channelType: "APNS", address: pushToken, optOut: optOut)
        return request.data
    }
}
