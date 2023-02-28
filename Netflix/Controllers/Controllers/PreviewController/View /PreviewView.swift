//
//  PreviewView.swift
//  Netflix
//
//  Created by KH on 28/02/2023.
//

import UIKit
import WebKit

final class PreviewView: UIView {
    
    var viewModel: PreviewViewViewModel
    
    // MARK: - Views
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = ""
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 6
        label.text = ""
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.isHidden = true
        return button
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    public func showDownloadButton() {
        downloadButton.isHidden = false
    }
    
    // MARK: - Init
    init(frame: CGRect, viewModel: PreviewViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        configureView()
        addConstraints()
    }
    
    public func configure(with items: [VideoElement]) {
        guard let url = URL(string: "https://www.youtube.com/embed/\(items[0].id?.videoId ?? "")") else { return }
        titleLabel.text = viewModel.displayTitle
        webView.load(URLRequest(url: url))
        overviewLabel.text = viewModel.displayOverView
    }
    
    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        addSubviews(views: titleLabel, overviewLabel, downloadButton, webView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300),
    
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
    
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
    
            downloadButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 25),
            downloadButton.widthAnchor.constraint(equalToConstant: 140),
            downloadButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
}
