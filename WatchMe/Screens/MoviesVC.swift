//
//  MoviesVC.swift
//  WatchMe
//
//  Created by Fatih Kilit on 11.08.2022.
//

import UIKit

class MoviesVC: UIViewController {
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var label: UILabel!
    
    private var popularMoviesResult: [PopularMoviesResult] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)
        
        configureScrollView()
        configureContentView()
        
        getPopularMovies()
    }
    
    private func getPopularMovies() {
        NetworkingManager.shared.getPopularMovies(page: 1) { [weak self] result in
            switch result {
            case .success(let popularMovies):
                self?.popularMoviesResult = popularMovies
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func configureScrollView() {
        scrollView = UIScrollView(frame: .zero)
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.pinToEdges(of: view)
    }
    
    private func configureContentView() {
        contentView = UIView(frame: .zero)
        scrollView.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.pinToEdges(of: scrollView)
        
        // widthAnchor and heightAnchor have to be specified.
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
}
