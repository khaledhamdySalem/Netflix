//
//  UpComingViewController.swift
//  Netflix
//
//  Created by KH on 26/02/2023.
//

import UIKit
import Combine

class UpComingViewController: UIViewController {
    
    var viewModel = UpComingViewViewModel()
    private var token: Set<AnyCancellable> = []
    
    let activityIndicator: UIActivityIndicatorView = {
        let ac = UIActivityIndicatorView()
        ac.startAnimating()
        ac.translatesAutoresizingMaskIntoConstraints = false
        ac.style = .large
        return ac
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addConstraints()
        setBinders()
        viewModel.fetchUpcomingMovies { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
        }
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
        tableView.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "UpComing"
        
        view.addSubview(tableView)
        tableView.addSubview(activityIndicator)
    }
    
    private func addConstraints() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 100).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
}

extension UpComingViewController: UITableViewDataSource, UITableViewDelegate {
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
