//
//  AWSPinpointResponse.swift
//  AWS3A-iOS
//
//  Created by Mark Evans on 9/11/19.
//  Copyright © 2019 3Advance LLC. All rights reserved.
//

import Foundation

public struct AWSPinpointResponse: Codable {
    public var RequestID: String?
    public var Message: String?
    public var requestId: String?
    public var message: String?
    public var channelType: String?
    public var address: String?
    public var endpointStatus: String?
    public var optOut: String?
    public var effectiveDate: String?
    public var user: UserParams?
    public var applicationId: String?
    public var endpointId: String?
    public var cohortId: String?
    public var creationDate: String?

    enum CodingKeys: String, CodingKey {
        case RequestID = "RequestID"
        case Message = "Message"
        case requestId = "RequestId"
        case message = "message"
        case channelType = "ChannelType"
        case address = "Address"
        case endpointStatus = "EndpointStatus"
        case optOut = "OptOut"
        case effectiveDate = "EffectiveDate"
        case user = "User"
        case applicationId = "ApplicationId"
        case endpointId = "Id"
        case cohortId = "CohortId"
        case creationDate = "CreationDate"
    }
}

public extension AWSPinpointResponse {
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
