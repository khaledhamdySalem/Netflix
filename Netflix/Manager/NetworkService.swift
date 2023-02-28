//
//  NetworkService.swift
//  Netflix
//
//  Created by KH on 26/02/2023.
//

import Foundation

struct Constants {
    static let API_KEY = "a6a529e2200060ce5635a0b144329c2e"
    static let base_url = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyDqX8axTGeNpXRiISTGL7Tya7fjKJDYi4g"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

final class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    
    public func getTrendingGeneric<T: Codable>(urlString: String, complition: @escaping ((Result<T, Error>) -> Void)) {
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, err in
            
            guard let data = data, err == nil else { return }
            
            if let err = err {
                complition(.failure(err))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                complition(.success(result))
            } catch let err {
                complition(.failure(err))
                return
            }
        }.resume()
    }
    
    public func getTrendingMovies(complition: @escaping ((Result<TrendingTitleResponse, Error>) -> Void)) {
        let urlString = "\(Constants.base_url)/3/trending/movie/day?api_key=\(Constants.API_KEY)"
        getTrendingGeneric(urlString: urlString, complition: complition)
    }
    
    public func getTrendingTvs(complition: @escaping ((Result<TrendingTitleResponse, Error>) -> Void)) {
        let urlString = "\(Constants.base_url)/3/trending/tv/day?api_key=\(Constants.API_KEY)"
        getTrendingGeneric(urlString: urlString, complition: complition)
    }
    
    func getUpcomingMovies(complition: @escaping ((Result<TrendingTitleResponse, Error>) -> Void)) {
        let urlString = "\(Constants.base_url)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1"
        getTrendingGeneric(urlString: urlString, complition: complition)
    }
    
    func getPopular(complition: @escaping ((Result<TrendingTitleResponse, Error>) -> Void)) {
        let urlString = "\(Constants.base_url)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1"
        getTrendingGeneric(urlString: urlString, complition: complition)
    }
    
    func getTopRated(complition: @escaping ((Result<TrendingTitleResponse, Error>) -> Void)) {
        let urlString = "\(Constants.base_url)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1"
        getTrendingGeneric(urlString: urlString, complition: complition)
    }
    
    func getDiscoverMovies(complition: @escaping ((Result<TrendingTitleResponse, Error>) -> Void)) {
        let urlString = "\(Constants.base_url)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
        getTrendingGeneric(urlString: urlString, complition: complition)
    }
    
    func search(with query: String, completion: @escaping (Result<TrendingTitleResponse, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let urlString = "\(Constants.base_url)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)"
        getTrendingGeneric(urlString: urlString, complition: completion)
    }
    
    func getMovie(with query: String, completion: @escaping (Result<YoutubeSearchResponse, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let urlString = "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)"
        getTrendingGeneric(urlString: urlString, complition: completion)
    }
}
