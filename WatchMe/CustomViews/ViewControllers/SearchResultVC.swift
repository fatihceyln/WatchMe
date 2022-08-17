//
//  SearchResultVC.swift
//  WatchMe
//
//  Created by Fatih Kilit on 17.08.2022.
//

import UIKit

class SearchResultVC: UIViewController {

    private var tableView: UITableView!
    
    private var results: [MovieResult] = []
    private var query: String = ""
    
    init(results: [MovieResult], query: String) {
        super.init(nibName: nil, bundle: nil)
        self.results = results
        self.query = query
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = query
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero)
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.reuseID)
        
        tableView.pinToEdges(of: view)
    }
}

extension SearchResultVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.reuseID) as! SearchCell
        cell.set(movie: results[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NetworkingManager.shared.downloadMovieDetail(urlString: ApiUrls.movieDetail(id: results[indexPath.row].id?.description ?? "")) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let detail):
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(MovieDetailVC(movieDetail: detail), animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(110)
    }
}
