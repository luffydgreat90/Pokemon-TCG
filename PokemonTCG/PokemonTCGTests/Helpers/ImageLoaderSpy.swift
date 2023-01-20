//
//  ImageLoaderSpy.swift
//  PokemonTCGTests
//
//  Created by Marlon Ansale on 1/20/23.
//

import Foundation
import PokemonFeed
import Combine

final class ImageLoaderSpy {
    private var imageRequests =  [(url: URL, publisher: PassthroughSubject<Data, Error>)]()
    private(set) var cancelledImageURLs = [URL]()
    
    var loadedImageURLs: [URL] {
        return imageRequests.map { $0.url }
    }
    
    func loadImageData(from url: URL?) -> AnyPublisher<Data, Error>  {
        guard let url = url else{
            return Future { complete in
                complete(.failure(LocalImageDataLoader.LoadError.notFound))
            }.eraseToAnyPublisher()
        }
        
        let publisher = PassthroughSubject<Data, Error>()
        imageRequests.append((url, publisher))
        return publisher.handleEvents(receiveCancel: { [weak self] in
            self?.cancelledImageURLs.append(url)
        }).eraseToAnyPublisher()
    }
    
    func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
        imageRequests[index].publisher.send(imageData)
        imageRequests[index].publisher.send(completion: .finished)
    }

    func completeImageLoadingWithError(at index: Int = 0) {
        imageRequests[index].publisher.send(completion: .failure(anyNSError()))
    }
}
