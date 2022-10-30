//
//  Network.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import Foundation

extension URLSession {
    
    private struct AssociatedKey {
        static var environmentKey: Void?
    }
    
    var environment: EnvironmentProtocol? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.environmentKey) as? EnvironmentProtocol
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKey.environmentKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension URLSession {
    
    /// Fetch data from remote server.
    /// - Parameters:
    ///   - request: Request.
    ///   - environment: Instance of EnvironmentProtocol.
    ///   - encoding: Encoding you are using, default is json.
    ///   - decoding: Decoding you are using, default is json.
    ///   - completion: Callback block.
    func fetch<ResponseType: Decodable>(_ request: Request<ResponseType>, on environment: EnvironmentProtocol? = nil, encoding: NetworkEncoding = .json, decoding: NetworkDecoding<ResponseType> = .json, completion: @escaping (Result<ResponseType, NetworkError>) -> Void) {
        guard let onUsingEnvironment = environment ?? self.environment else {
            fatalError("must set network environment before use")
        }
        
        guard let urlRequest = request.urlRequest(from: onUsingEnvironment, encoding: encoding) else {
            completion(.failure(.urlRequestCreateError))
            return
        }
        
        let task = dataTask(with: urlRequest) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.httpUrlResponseError))
                return
            }
            if let error = error {
                completion(.failure(.genericError(errorMessage: error.localizedDescription)))
                return
            }
            
            let statusCode = StatusCode(rawValue: response.statusCode)
            if let error = statusCode.testStatus() {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(.httpDataError))
                return
            }
            
            guard let result = decoding.parsing(data) else {
                completion(.failure(.httpDataParsingError))
                return
            }
            
            completion(.success(result))
            return
        }
        
        task.resume()
    }
}

extension URLSession {
    
    func fetch<ResponseType: Decodable>(_ request: Request<ResponseType>, on environment: EnvironmentProtocol? = nil, encoding: NetworkEncoding = .json, decoding: NetworkDecoding<ResponseType> = .json) async throws -> ResponseType {
        return try await withCheckedThrowingContinuation { continuation in
            fetch(request, on: environment, encoding: encoding, decoding: decoding) { result in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
