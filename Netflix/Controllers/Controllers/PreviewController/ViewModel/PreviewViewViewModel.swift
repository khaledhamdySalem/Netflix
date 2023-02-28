//
//  PreviewViewViewModel.swift
//  Netflix
//
//  Created by KH on 28/02/2023.
//

import Foundation

final class PreviewViewViewModel {
    
    let title: String
    let overview: String
    var viedoUrl: URL?
    
    init(title: String, overview: String, viedoUrl: URL? = nil) {
        self.title = title
        self.overview = overview
        self.viedoUrl = viedoUrl
    }
    
    public var displayTitle: String {
        return title
    }
    
    public var displayOverView: String {
        return overview
    }
    
    public func fetchVideo(complition: @escaping (Result<[VideoElement], Error>) -> Void) {
        NetworkService.shared.getMovie(with: title) { result in
            switch result {
            case .success(let res):
                DispatchQueue.main.async {
                    let items = res.items
                    complition(.success(items ?? []))
                }
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
    
}
