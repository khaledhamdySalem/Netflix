//
//  UpcomingTableViewCell.swift
//  Netflix
//
//  Created by KH on 27/02/2023.
//

import UIKit

class UpcomingTableViewCell: UITableViewCell {

    static let identifier = "UpcomingTableViewCell"
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40)), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello Poster Film"
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let posterImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .systemBackground
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        addConstraints()
    }
    
    private func configureView() {
        contentView.addSubviews(views: posterImageView, titleLabel, playButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 150),
            
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 40),
            
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -16)
        ])
    }
    
    public func configure(with viewModel: UpcomingTableViewCellViewModel) {
        posterImageView.sd_setImage(with: viewModel.imageUrl)
        titleLabel.text = viewModel.displayTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    func addSubviews(views: UIView...) {
        views.forEach { view in
            addSubview(view)
        }
    }
}
