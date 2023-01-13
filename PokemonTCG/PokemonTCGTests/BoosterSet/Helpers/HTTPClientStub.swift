//
//  HTTPClientStub.swift
//  PokemonTCGTests
//
//  Created by Marlon Ansale on 1/13/23.
//

import Foundation
import PokemonFeed

class HTTPClientStub: HTTPClient {

    private class Task: HTTPClientTask {
        func cancel() {}
    }

    private let stub: (URL) -> HTTPClient.Result
    
    init(stub: @escaping (URL) -> HTTPClient.Result) {
        self.stub = stub
    }
    
    func get(from url: URL?, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        if let url = url {
            completion(stub(url))
        }
        
        return Task()
    }
}

extension HTTPClientStub {
    static var offline: HTTPClientStub {
        HTTPClientStub(stub: { _ in .failure(NSError(domain: "offline", code: 0)) })
    }
    
    static func online(_ stub: @escaping (URL) -> (Data, HTTPURLResponse)) -> HTTPClientStub {
        HTTPClientStub { url in .success(stub(url)) }
    }
}
