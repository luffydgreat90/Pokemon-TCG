//
//  URLSessionHTTPClient.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/3/23.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    public init(session: URLSession) {
        self.session = session
    }
    
    private enum LoadError: Error {
        case invalidURL
        case failed
    }

    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask

        func cancel() {
            wrapped.cancel()
        }
    }
    
    public func get(from url: URL?, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        guard let url = url else {
            return Result {
                throw LoadError.invalidURL
            } as! HTTPClientTask
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            completion(Result {
                
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw LoadError.failed
                }
            })
        }
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }
}
