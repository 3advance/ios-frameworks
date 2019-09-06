//
//  AWSError.swift
//  AWS3A-iOS
//
//  Created by Mark Evans on 9/5/19.
//  Copyright © 2019 3Advance LLC. All rights reserved.
//

import Foundation

struct AWSError: Codable {

    public static let unknownError = NSError(domain: "Internal Server Error", code: 500, userInfo: nil)
    public static let emptyPhoneNumberError = NSError(domain: "Phone Number should not be empty!", code: 400, userInfo: nil)
    public static let emptyCodeError = NSError(domain: "Code should not be empty!", code: 400, userInfo: nil)

    var message: String?

    enum CodingKeys: String, CodingKey {
        case message = "message"
    }
}

extension AWSError {
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
