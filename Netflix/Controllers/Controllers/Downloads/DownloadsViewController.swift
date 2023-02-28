//
//  DownloadsViewController.swift
//  Netflix
//
//  Created by KH on 26/02/2023.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    var titles = [TitleItem]()
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
        fetchDataFromDB()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleObserver), name: Notification.Name("downloadObject"), object: nil)
        
    }
    
    @objc func handleObserver() {
        fetchDataFromDB()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Downloads"
        view.addSubview(tableView)
    }
    
    private func addConstraints() {
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func fetchDataFromDB() {
        DataBasePersistenceManager.shared.fetchDataFromDB {[weak self]  result in
            switch result {
            case .success(let titles):
                DispatchQueue.main.async {
                    self?.titles = titles
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension DownloadsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as! UpcomingTableViewCell
        guard let titleName = titles[indexPath.row].original_title, let posterName = titles[indexPath.row].poster_path else { return UITableViewCell()}
        let viewModel = UpcomingTableViewCellViewModel(titleName: titleName, posterImage: posterName)
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewModel = PreviewViewViewModel(title: titles[indexPath.row].original_title ?? "",
                                             overview: titles[indexPath.row].overview ?? "",
                                             viedoUrl: URL(string: titles[indexPath.row].poster_path ?? ""))
        let vc = PreviewViewController(viewModel: viewModel)
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataBasePersistenceManager.shared.delete(item: titles[indexPath.row]) { result in
                switch result {
                case .success(_):
                    titles.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
}
