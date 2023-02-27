//
//  TitleCollectionViewCellViewModel.swift
//  Netflix
//
//  Created by KH on 26/02/2023.
//

import UIKit

struct TitleCollectionViewCellViewModel {
    
    private let image: String?
    
    init(image: String?) {
        self.image = image
    }
    
    public var imageUrl: URL? {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(image ?? "")") else { return nil}
        return url
    }
    
}
