//
//  HomeHeaderView.swift
//  Netflix
//
//  Created by KH on 26/02/2023.
//

import UIKit

class HomeHeaderView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "film")
        return imageView
    }()
    
    lazy var playButton = createButton(title: "Play")
    lazy var downloadButton = createButton(title: "Dowbload")
    lazy var stackView = UIStackView(arrangedSubviews: [playButton, downloadButton])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        addConstraints()
    }
    
    private func configureView() {
        addSubview(imageView)
        addGradiants()
        addSubview(stackView)
    }
    
    private func addConstraints() {
        
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 30
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            stackView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16)
        ])
    }
    
    private func addGradiants() {
        let gradiants = CAGradientLayer()
        gradiants.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradiants.locations = [0.5, 1.2]
        gradiants.frame = bounds
        layer.addSublayer(gradiants)
    }
    
    private func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = .clear
        button.tintColor = .label
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return button
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
