//
//  SearchViewController.swift
//  Netflix
//
//  Created by KH on 26/02/2023.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    var viewModel = UpComingViewViewModel()
    private var token: Set<AnyCancellable> = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search for movies, Tv ..."
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addConstraints()
        setBinders()
        viewModel.fetchUpcomingMovies {}
    }
    
    private func setBinders() {
        viewModel.$titles.sink { [weak self] titles in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }.store(in: &token)
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        searchController.searchResultsUpdater = self
    }
    
    private func addConstraints() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.titles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as! UpcomingTableViewCell
        guard let titleName = viewModel.titles?[indexPath.row].original_title, let posterName = viewModel.titles?[indexPath.row].poster_path else { return UITableViewCell()}
        let viewModel = UpcomingTableViewCellViewModel(titleName: titleName, posterImage: posterName)
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              query.trimmingCharacters(in: .whitespacesAndNewlines).count >= 3,
              let searchController = searchController.searchResultsController as? SearchResultViewController
        else { return }
        
        searchController.query = query
       
    }
}
