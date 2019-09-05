//
//  AWSService.swift
//  AWS3A-iOS
//
//  Created by Mark Evans on 9/5/19.
//  Copyright © 2019 3Advance LLC. All rights reserved.
//

import Foundation
import UIKit

@objc public class AWSService: NSObject {
    // MARK: Properties

    var session = URLSession()

    private let unknownError = NSError(domain: "Internal Server Error", code: 500, userInfo: nil)
    private var baseURL = ""
    private var clientId = ""

    public typealias AWSCompletionHandler = (_ success: Any?, _ error: NSError?) -> Void
    public typealias AWSCompletionBoolHandler = (_ success: Bool) -> Void

    // MARK: Shared Instance

    public static let shared: AWSService = {
        let instance = AWSService()
        instance.setupManager()
        return instance
    }()

    // MARK: Setup Methods

    private func setupManager() {
        let config = URLSessionConfiguration.default
        self.session = URLSession(configuration: config)
    }


    public func start(url: String?, clientId: String) {
        self.baseURL = url ?? "https://cognito-idp.us-east-1.amazonaws.com"
        self.clientId = clientId
    }

    // MARK: AWS Restful Methods

    public func registerUser(email: String, password: String, completion: @escaping AWSCompletionHandler) {
        DispatchQueue(label: "background", qos: .background).async {
            let urlRequest = AWSRequest.requestRegisterUser(url: self.baseURL, clientId: self.clientId, email: email, password: password)
            self.session.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(nil, self.handleError(responseCode: 500, data: nil, error: self.unknownError))
                    }
                    return
                }
                let responseCode = response.statusCode
                do {
                    if responseCode >= 200 && responseCode < 300 {
                        let res = try JSONDecoder().decode(AWSResponse.self, from: data)
                        DispatchQueue.main.async {
                            completion(res, nil)
                        }
                    }
                    else {
                        let errorObject = try JSONDecoder().decode(AWSError.self, from: data)
                        DispatchQueue.main.async {
                            completion(nil, self.handleError(responseCode: responseCode, error: errorObject))
                        }
                    }
                } catch let catchError {
                    DispatchQueue.main.async {
                        completion(nil, self.handleError(responseCode: responseCode, data: data, error: catchError))
                    }
                }
                }.resume()
        }
    }

    public func confirmRegisterUser(email: String, code: String, completion: @escaping AWSCompletionHandler) {
        DispatchQueue(label: "background", qos: .background).async {
            let urlRequest = AWSRequest.requestConfirmRegisterUser(url: self.baseURL, clientId: self.clientId, email: email, code: code)
            self.session.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(nil, self.handleError(responseCode: 500, data: nil, error: self.unknownError))
                    }
                    return
                }
                let responseCode = response.statusCode
                do {
                    if responseCode >= 200 && responseCode < 300 {
                        DispatchQueue.main.async {
                            completion(true, nil)
                        }
                    }
                    else {
                        let errorObject = try JSONDecoder().decode(AWSError.self, from: data)
                        DispatchQueue.main.async {
                            completion(nil, self.handleError(responseCode: responseCode, error: errorObject))
                        }
                    }
                } catch let catchError {
                    DispatchQueue.main.async {
                        completion(nil, self.handleError(responseCode: responseCode, data: data, error: catchError))
                    }
                }
                }.resume()
        }
    }

    public func loginUser(email: String, password: String, completion: @escaping AWSCompletionHandler) {
        DispatchQueue(label: "background", qos: .background).async {
            let urlRequest = AWSRequest.requestLoginUser(url: self.baseURL, clientId: self.clientId, email: email, password: password)
            self.session.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(nil, self.handleError(responseCode: 500, data: nil, error: self.unknownError))
                    }
                    return
                }
                let responseCode = response.statusCode
                do {
                    if responseCode >= 200 && responseCode < 300 {
                        let res = try JSONDecoder().decode(AWSResponse.self, from: data)
                        DispatchQueue.main.async {
                            completion(res, nil)
                        }
                    }
                    else {
                        let errorObject = try JSONDecoder().decode(AWSError.self, from: data)
                        DispatchQueue.main.async {
                            completion(nil, self.handleError(responseCode: responseCode, error: errorObject))
                        }
                    }
                } catch let catchError {
                    DispatchQueue.main.async {
                        completion(nil, self.handleError(responseCode: responseCode, data: data, error: catchError))
                    }
                }
                }.resume()
        }
    }

    public func confirmUser(email: String, newPassword: String, session: String, completion: @escaping AWSCompletionHandler) {
        DispatchQueue(label: "background", qos: .background).async {
            let urlRequest = AWSRequest.requestConfirmUser(url: self.baseURL, clientId: self.clientId, email: email, newPassword: newPassword, session: session)
            self.session.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(nil, self.handleError(responseCode: 500, data: nil, error: self.unknownError))
                    }
                    return
                }
                let responseCode = response.statusCode
                do {
                    if responseCode >= 200 && responseCode < 300 {
                        DispatchQueue.main.async {
                            completion(true, nil)
                        }
                    }
                    else {
                        let errorObject = try JSONDecoder().decode(AWSError.self, from: data)
                        DispatchQueue.main.async {
                            completion(nil, self.handleError(responseCode: responseCode, error: errorObject))
                        }
                    }
                } catch let catchError {
                    DispatchQueue.main.async {
                        completion(nil, self.handleError(responseCode: responseCode, data: data, error: catchError))
                    }
                }
                }.resume()
        }
    }

    public func refreshToken(refreshToken: String, completion: @escaping AWSCompletionHandler) {
        DispatchQueue(label: "background", qos: .background).async {
            let urlRequest = AWSRequest.requestRefreshToken(url: self.baseURL, clientId: self.clientId, refreshToken: refreshToken)
            self.session.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(nil, self.handleError(responseCode: 500, data: nil, error: self.unknownError))
                    }
                    return
                }
                let responseCode = response.statusCode
                do {
                    if responseCode >= 200 && responseCode < 300 {
                        let res = try JSONDecoder().decode(AWSResponse.self, from: data)
                        DispatchQueue.main.async {
                            completion(res, nil)
                        }
                    }
                    else {
                        let errorObject = try JSONDecoder().decode(AWSError.self, from: data)
                        DispatchQueue.main.async {
                            completion(nil, self.handleError(responseCode: responseCode, error: errorObject))
                        }
                    }
                } catch let catchError {
                    DispatchQueue.main.async {
                        completion(nil, self.handleError(responseCode: responseCode, data: data, error: catchError))
                    }
                }
            }.resume()
        }
    }

    // MARK: Error Handling Methods

    func handleError(responseCode: Int, data: Data?, error: Error?) -> NSError? {
        let errorMessage = error?.localizedDescription ?? "Internal Server Error"
        guard let data = data else {
            return NSError(domain: errorMessage, code: responseCode, userInfo: nil)
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            print("handleError json: \(json)")
//            let errorObject = Mapper<ClientError>().map(JSONObject: json)
            return NSError(domain: errorMessage, code: responseCode, userInfo: nil) //NSError(domain: errorObject?.error ?? errorMessage, code: error?.asAFError?.responseCode ?? 500, userInfo: nil)
        } catch _ {
            return NSError(domain: errorMessage, code: responseCode, userInfo: nil)
        }
    }

    func handleError(responseCode: Int, error: AWSError?) -> NSError? {
        let errorMessage = error?.message ?? "Internal Server Error"
        return NSError(domain: errorMessage, code: responseCode, userInfo: nil)
    }
}
