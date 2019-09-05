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

    private var awsSession = URLSession()
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
        self.awsSession = URLSession(configuration: config)
    }


    public func initialize(clientId: String) {
        self.clientId = clientId
    }

    // MARK: AWS Restful Methods

    public func registerUser(email: String, password: String, completion: @escaping AWSCompletionHandler) {
        DispatchQueue(label: "background", qos: .background).async {
            let urlRequest = AWSRequest.requestRegisterUser(clientId: self.clientId, email: email, password: password)
            self.awsSession.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: AWSError.unknownError.code, data: nil, error: AWSError.unknownError))
                    }
                    return
                }
                let responseCode = response.statusCode
                do {
                    if responseCode.isValid {
                        let res = try JSONDecoder().decode(AWSResponse.self, from: data)
                        DispatchQueue.main.async {
                            completion(res, nil)
                        }
                    }
                    else {
                        let errorObject = try JSONDecoder().decode(AWSError.self, from: data)
                        DispatchQueue.main.async {
                            completion(nil, self.awsHandleError(responseCode: responseCode, error: errorObject))
                        }
                    }
                } catch let catchError {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: responseCode, data: data, error: catchError))
                    }
                }
                }.resume()
        }
    }

    public func confirmRegisterUser(email: String, code: String, completion: @escaping AWSCompletionHandler) {
        DispatchQueue(label: "background", qos: .background).async {
            let urlRequest = AWSRequest.requestConfirmRegisterUser(clientId: self.clientId, email: email, code: code)
            self.awsSession.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: AWSError.unknownError.code, data: nil, error: AWSError.unknownError))
                    }
                    return
                }
                let responseCode = response.statusCode
                do {
                    if responseCode.isValid {
                        DispatchQueue.main.async {
                            completion(true, nil)
                        }
                    }
                    else {
                        let errorObject = try JSONDecoder().decode(AWSError.self, from: data)
                        DispatchQueue.main.async {
                            completion(nil, self.awsHandleError(responseCode: responseCode, error: errorObject))
                        }
                    }
                } catch let catchError {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: responseCode, data: data, error: catchError))
                    }
                }
                }.resume()
        }
    }

    public func loginUser(email: String, password: String, completion: @escaping AWSCompletionHandler) {
        DispatchQueue(label: "background", qos: .background).async {
            let urlRequest = AWSRequest.requestLoginUser(clientId: self.clientId, email: email, password: password)
            self.awsSession.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: AWSError.unknownError.code, data: nil, error: AWSError.unknownError))
                    }
                    return
                }
                let responseCode = response.statusCode
                do {
                    if responseCode.isValid {
                        let res = try JSONDecoder().decode(AWSResponse.self, from: data)
                        DispatchQueue.main.async {
                            completion(res, nil)
                        }
                    }
                    else {
                        let errorObject = try JSONDecoder().decode(AWSError.self, from: data)
                        DispatchQueue.main.async {
                            completion(nil, self.awsHandleError(responseCode: responseCode, error: errorObject))
                        }
                    }
                } catch let catchError {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: responseCode, data: data, error: catchError))
                    }
                }
                }.resume()
        }
    }

    public func confirmUser(email: String, newPassword: String, session: String, completion: @escaping AWSCompletionHandler) {
        DispatchQueue(label: "background", qos: .background).async {
            let urlRequest = AWSRequest.requestConfirmUser(clientId: self.clientId, email: email, newPassword: newPassword, session: session)
            self.awsSession.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: AWSError.unknownError.code, data: nil, error: AWSError.unknownError))
                    }
                    return
                }
                let responseCode = response.statusCode
                do {
                    if responseCode.isValid {
                        DispatchQueue.main.async {
                            completion(true, nil)
                        }
                    }
                    else {
                        let errorObject = try JSONDecoder().decode(AWSError.self, from: data)
                        DispatchQueue.main.async {
                            completion(nil, self.awsHandleError(responseCode: responseCode, error: errorObject))
                        }
                    }
                } catch let catchError {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: responseCode, data: data, error: catchError))
                    }
                }
                }.resume()
        }
    }

    public func refreshToken(refreshToken: String, completion: @escaping AWSCompletionHandler) {
        DispatchQueue(label: "background", qos: .background).async {
            let urlRequest = AWSRequest.requestRefreshToken(clientId: self.clientId, refreshToken: refreshToken)
            self.awsSession.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: AWSError.unknownError.code, data: nil, error: AWSError.unknownError))
                    }
                    return
                }
                let responseCode = response.statusCode
                do {
                    if responseCode.isValid {
                        let res = try JSONDecoder().decode(AWSResponse.self, from: data)
                        DispatchQueue.main.async {
                            completion(res, nil)
                        }
                    }
                    else {
                        let errorObject = try JSONDecoder().decode(AWSError.self, from: data)
                        DispatchQueue.main.async {
                            completion(nil, self.awsHandleError(responseCode: responseCode, error: errorObject))
                        }
                    }
                } catch let catchError {
                    DispatchQueue.main.async {
                        completion(nil, self.awsHandleError(responseCode: responseCode, data: data, error: catchError))
                    }
                }
            }.resume()
        }
    }

    // MARK: Error Handling Methods

    private func awsHandleError(responseCode: Int, data: Data?, error: Error?) -> NSError? {
        let errorMessage = error?.localizedDescription ?? AWSError.unknownError.domain
        guard let data = data else {
            return NSError(domain: errorMessage, code: responseCode, userInfo: nil)
        }
        do {
            let errorObject = try JSONDecoder().decode(AWSError.self, from: data)
            return self.awsHandleError(responseCode: responseCode, error: errorObject)
        } catch _ {
            return NSError(domain: errorMessage, code: responseCode, userInfo: nil)
        }
    }

    private func awsHandleError(responseCode: Int, error: AWSError?) -> NSError? {
        let errorMessage = error?.message ?? AWSError.unknownError.domain
        return NSError(domain: errorMessage, code: responseCode, userInfo: nil)
    }
}
