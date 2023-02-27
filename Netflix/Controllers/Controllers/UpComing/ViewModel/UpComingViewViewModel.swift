//
//  UpComingViewViewModel.swift
//  Netflix
//
//  Created by KH on 27/02/2023.
//

import Foundation
import Combine

final class UpComingViewViewModel {
    
    @Published var titles: [Title]?
    
    func fetchUpcomingMovies(complition: @escaping () -> ()) {
        NetworkService.shared.getUpcomingMovies { [weak self] result in
            switch result {
            case .success(let res):
                self?.titles = res.results
                complition()
            case .failure(let error):
                print(error)
            }
        }
    }
}
