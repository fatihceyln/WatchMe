//
//  WatchlistVC.swift
//  WatchMe
//
//  Created by Fatih Kilit on 11.08.2022.
//

import UIKit

class WatchlistVC: UIViewController {
    
    private var contents: [ContentDetail] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getSavedContents()
    }
    
    private func getSavedContents() {
        Store.retrieveContents { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let contents):
                self.contents = contents
            case .failure(let error):
                print(error)
            }
        }
    }
}
