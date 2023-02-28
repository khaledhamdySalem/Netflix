//
//  PreviewViewController.swift
//  Netflix
//
//  Created by KH on 27/02/2023.
//

import UIKit
import WebKit

class PreviewViewController: UIViewController {
    
    // MARK: - Views
    var previewView: PreviewView
    var viewModel: PreviewViewViewModel
    
    let activityIndicator: UIActivityIndicatorView = {
        let ac = UIActivityIndicatorView()
        ac.startAnimating()
        ac.translatesAutoresizingMaskIntoConstraints = false
        ac.style = .large
        return ac
    }()
    
    init(viewModel: PreviewViewViewModel) {
        self.viewModel = viewModel
        self.previewView = PreviewView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conigureView()
        addConstraints()
        fetchData()
    }
    
    private func fetchData() {
        viewModel.fetchVideo { [weak self] result in
            switch result {
            case .success(let items):
                DispatchQueue.main.async {
                    self?.previewView.configure(with: items)
                    self?.activityIndicator.stopAnimating()
                    self?.previewView.showDownloadButton()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func conigureView() {
        view.addSubview(previewView)
        view.addSubview(activityIndicator)
        view.backgroundColor = .systemBackground
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            previewView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            previewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
