//
//  HomeTableViewCell.swift
//  Netflix
//
//  Created by KH on 26/02/2023.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    static let identifier = "HomeTableViewCell"
    
    var titles: [Title] = [Title]()
    weak var delegate: HomeTableViewCellDelegate?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 140, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        addConstraints()
    }
    
    private func configureView() {
        contentView.addSubview(collectionView)
        addSubview(collectionView)
        contentView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    
    public func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func downloadTitleAt(indexPath: IndexPath) {
        DataBasePersistenceManager.shared.downloadTitleWith(model: titles[indexPath.item]) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: Notification.Name("downloadObject"), object: nil)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension HomeTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as! TitleCollectionViewCell
        
        let viewModel = TitleCollectionViewCellViewModel(image: titles[indexPath.item].poster_path ?? "")
        
        cell.configure(viewModel: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let title = titles[indexPath.item].original_title ?? titles[indexPath.item].original_name else { return }
        delegate?.didopenVideo(with: title, titleOverview: titles[indexPath.item].overview ?? "")
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
                let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    self?.downloadTitleAt(indexPath: indexPath)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            }
        
        return config
    }
}


protocol HomeTableViewCellDelegate: AnyObject {
    func didopenVideo(with videoTitle: String, titleOverview: String)
}
