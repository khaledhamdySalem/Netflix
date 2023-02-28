//
//  TitleCollectionViewCell.swift
//  Netflix
//
//  Created by KH on 26/02/2023.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        addConstraints()
    }
    
    private func configureView() {
        backgroundColor = .purple
        contentView.addSubview(posterImageView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    public func configure(viewModel: TitleCollectionViewCellViewModel) {
        posterImageView.sd_setImage(with: viewModel.imageUrl,
                                    placeholderImage: #imageLiteral(resourceName: "placeholder.png"))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
