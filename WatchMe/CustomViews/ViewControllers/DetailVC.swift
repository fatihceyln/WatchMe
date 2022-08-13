//
//  DetailVC.swift
//  WatchMe
//
//  Created by Fatih Kilit on 13.08.2022.
//

import UIKit

class DetailVC: UIViewController {
    
    private var scrollView: UIScrollView!
    private var containerStackView: UIStackView!
    
    private var headerView: HeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureScrollView()
        configureContainerStackView()
        
        configureHeaderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
}

extension DetailVC {
    private func configureHeaderView() {
        headerView = HeaderView(superContainerView: containerStackView)
    }
}

extension DetailVC {
    private func configureScrollView() {
        scrollView = UIScrollView(frame: .zero)
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.pinToEdges(of: view)
    }
    
    private func configureContainerStackView() {
        containerStackView = UIStackView(frame: .zero)
        scrollView.addSubview(containerStackView)
        
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.axis = .vertical
        containerStackView.distribution = .fillEqually
        
        containerStackView.pinToEdges(of: scrollView)
        
        containerStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
}
