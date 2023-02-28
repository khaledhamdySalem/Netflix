//
//  HomeViewController.swift
//  Netflix
//
//  Created by KH on 26/02/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    enum SectionTitle: String, CaseIterable {
        case trending_movie = "Trending Movies"
        case trending_tv = "Trending Tv"
        case popular = "Popular"
        case upcoming_movie = "Upcoming Movies"
        case top_rated = "Top rated"
    }
    
    // MARK: - ViewModel
    var viewModel = HomeTableCellViewModel()
    var titles = [Title]()
    
    // MARK: - Views
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        return tableView
    }()
    
    fileprivate var headerView: HomeHeaderView?
    fileprivate var randowmTitle: Title?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addConstraints()
        configureNavigationBar()
        createHeaderView()
        configureHeaderView()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        title = "Home"
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func addConstraints() {
        tableView.frame = view.bounds
    }
    
    private func configureNavigationBar() {
        let logo = #imageLiteral(resourceName: "netflixLogo")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logo.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureHeaderView() {
        NetworkService.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let res):
                self?.randowmTitle = res.results.randomElement()
                self?.headerView?.configure(imagePath: self?.randowmTitle?.poster_path ?? "")
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - Datasource & Delegate
extension HomeViewController: UITableViewDataSource & UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionTitle.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as! HomeTableViewCell
        cell.delegate = self
       
        switch SectionTitle.allCases[indexPath.section] {
        case .trending_movie:
            viewModel.fetchTrendingMovies { titles in
                cell.configure(with: titles)
                self.titles = titles
            }
        case .trending_tv:
            viewModel.fetchTrendingTV { titles in
                cell.configure(with: titles)
            }
        case .popular:
            viewModel.fetchPopular { titles in
                cell.configure(with: titles)
            }
        case .upcoming_movie:
            viewModel.fetchUpcomingMovies { titles in
                cell.configure(with: titles)
            }
        case .top_rated:
            viewModel.fetchTopRated { titles in
                cell.configure(with: titles)
            }
        }
        return cell
    }
}

// MARK: - HeaderView
extension HomeViewController {
    
    private func createHeaderView() {
        let homeHeaderView = HomeHeaderView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 450))
        self.headerView = homeHeaderView
        tableView.tableHeaderView = homeHeaderView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        SectionTitle.allCases[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.textLabel?.font = UIFont.systemFont(ofSize: 18)
        headerView.textLabel?.textColor = .white
        headerView.textLabel?.text = headerView.textLabel?.text?.capitalized
    }
}

// MARK: - ScrollView
extension HomeViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defultOffset = view.safeAreaInsets.top
        let offest = scrollView.contentOffset.y + defultOffset
        navigationController?.navigationBar.transform = CGAffineTransform(translationX: 0, y: min(0, -offest))
    }
}

extension HomeViewController: HomeTableViewCellDelegate {
    func didopenVideo(with videoTitle: String, titleOverview: String) {
        let viewModel = PreviewViewViewModel(title: videoTitle, overview: titleOverview, viedoUrl: nil)
        let vc = PreviewViewController(viewModel: viewModel)
        present(vc, animated: true)
    }
}
