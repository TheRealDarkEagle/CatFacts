//
//  UserFactsView.swift
//  CatFacts
//
//  Created by Baur Versand on 16.06.20.
//  Copyright © 2020 Empiriecom. All rights reserved.
//

import UIKit
import RxSwift

class UserFactsView: UITableViewController {
    
    // MARK: - Properties
    var userFactsModel: UserFactsViewModel?
    let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup Functions
    
    func setup() {
     view.backgroundColor = .white
     tableView.delegate = nil
     tableView.dataSource = nil
     tableView.rowHeight = UITableView.automaticDimension
     tableView.estimatedRowHeight = 1600
     tableView.register(ReuseCell.self, forCellReuseIdentifier: "Cell")
        
     tableView.rx.setDelegate(self).disposed(by: disposebag)
     userFactsModel?.userFacts.subscribe(onNext: { [weak self] _ in
            self?.tableView.reloadData()
        }).disposed(by: disposebag)
     userFactsModel?.userFacts.bind(to: tableView.rx.items(cellIdentifier: "Cell")) { _, fact, cell in
            cell.textLabel?.text = "\(fact.fact)"
            cell.textLabel?.numberOfLines = 0
        }.disposed(by: disposebag)
        
     self.title = userFactsModel?.selectedUser
    }
}
