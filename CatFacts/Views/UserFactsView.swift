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
   
   // MARK: - Setup Function
   
   func setup() {
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 1600
        tableView.register(ReuseCell.self, forCellReuseIdentifier: "Cell")
        tableView.rx.setDelegate(self).disposed(by: disposebag)
        self.title = userFactsModel?.selectedUser
        setupBindings()
   }
   
   private func setupBindings() {
       userFactsModel?.userFacts.bind(to: tableView.rx.items(cellIdentifier: "Cell")) { _, fact, cell in
               cell.textLabel?.text = "\(fact.fact)"
               cell.textLabel?.numberOfLines = 0
               cell.textLabel?.font = .systemFont(ofSize: 20)
               cell.backgroundColor = cell.backgroundColor?.withAlphaComponent(0.4)
           }.disposed(by: disposebag)
       userFactsModel?.backgroundImage.subscribe(onNext: { [weak self] imgName in
           self?.tableView.backgroundView = UIImageView(image: UIImage(named: imgName))
       }).disposed(by: disposebag)
   }
}
