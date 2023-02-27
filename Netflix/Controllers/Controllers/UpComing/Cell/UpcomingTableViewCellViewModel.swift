//
//  UpcomingTableViewCellViewModel.swift
//  Netflix
//
//  Created by KH on 27/02/2023.
//

import Foundation


final class UpcomingTableViewCellViewModel {
 
    private let titleName: String
    
    private let posterImage: String
    
    init(titleName: String, posterImage: String) {
        self.titleName = titleName
        self.posterImage = posterImage
    }
    
    var imageUrl: URL? {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterImage)") else { return nil}
        return url
    }
    
    var displayTitle: String {
        return titleName
    }
    
}
