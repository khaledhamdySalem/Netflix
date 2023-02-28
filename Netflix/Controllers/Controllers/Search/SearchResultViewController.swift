//
//  SearchResultViewController.swift
//  Netflix
//
//  Created by KH on 27/02/2023.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: (UIScreen.main.bounds.width/3) - 15, height: 200)
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let ac = UIActivityIndicatorView()
        ac.startAnimating()
        ac.translatesAutoresizingMaskIntoConstraints = false
        ac.style = .large
        return ac
    }()
    
    private var titles = [Title]()
    
    var query: String? {
        didSet {
            self.fetchData(query: query ?? "")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addConstraints()
    }
    
    private func configureView() {
        title = "Search"
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.addSubview(activityIndicator)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func fetchData(query: String) {
        NetworkService.shared.search(with: query) { [weak self] res in
            switch res {
            case .success(let res):
                self?.titles = res.results
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SearchResultViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as! TitleCollectionViewCell
        let viewModel = TitleCollectionViewCellViewModel(image: titles[indexPath.item].poster_path)
        cell.configure(viewModel: viewModel)
        return cell
    }
}
