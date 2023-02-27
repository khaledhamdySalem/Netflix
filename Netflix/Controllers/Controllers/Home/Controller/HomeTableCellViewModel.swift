//
//  HomeTableCellViewModel.swift
//  Netflix
//
//  Created by KH on 26/02/2023.
//

import UIKit

final class HomeTableCellViewModel {
    
    public func fetchTrendingMovies(complition: @escaping(([Title]) -> Void)) {
        NetworkService.shared.getTrendingMovies { result in
            switch result {
            case .success(let title):
                complition(title.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func fetchTrendingTV(complition: @escaping(([Title]) -> Void)) {
        NetworkService.shared.getTrendingTvs { result in
            switch result {
            case .success(let title):
                complition(title.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func fetchPopular(complition: @escaping(([Title]) -> Void)) {
        NetworkService.shared.getPopular { result in
            switch result {
            case .success(let title):
                complition(title.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func fetchUpcomingMovies(complition: @escaping(([Title]) -> Void)) {
        NetworkService.shared.getUpcomingMovies { result in
            switch result {
            case .success(let title):
                complition(title.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func fetchTopRated(complition: @escaping(([Title]) -> Void)) {
        NetworkService.shared.getTopRated {  result in
            switch result {
            case .success(let title):
                complition(title.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
