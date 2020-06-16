//
//  StartView.swift
//  CatFacts
//
//  Created by Baur Versand on 15.06.20.
//  Copyright © 2020 Empiriecom. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

// MARK: - TODO LieblingsFacts Speichern?

class StartView: UIViewController {
    
    // MARK: - Properties
    var catFactLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 50, y: 50, width: 60, height: 100))
        label.text = ""
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    var catFactAuthor: UILabel = {
        let label = UILabel(frame: CGRect(x: 50, y: 50, width: 60, height: 100))
        label.text = ""
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    var image: UIImageView = {
        let image = UIImageView(image: UIImage(named: "babyKitty"))
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.cornerRadius = image.frame.height/4
        image.clipsToBounds = true
        return image
    }()
    
    var moreFactsButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 250, height: 30)
        button.backgroundColor  = .systemGray6
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    var moreFactsFromUserButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Click here for more Facts from:", for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 250, height: 30)
        button.addTarget(self, action: #selector(moreFromUserAction), for: .touchUpInside)
        return button
    }()
    
    var viewModel = StartViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setupBindings()
        setup()
    }
    
    // MARK: - Setup Functions
    private func setupBindings() {
        viewModel.catFact.subscribe(onNext: { [weak self] fact in
            self?.catFactAuthor.text = fact.author
            self?.catFactLabel.text = fact.fact
            self?.moreFactsFromUserButton.isHidden = false
            }).disposed(by: disposeBag)
        
        viewModel.buttonText.distinctUntilChanged().subscribe(onNext: { [weak self] text in
            self?.moreFactsButton.setTitle(text, for: .normal)
            //self?.moreFactsFromUserButton.isHidden = false
        }).disposed(by: disposeBag)
        
        viewModel.isLoading.subscribe(onNext: { [weak self] isloading in
            if isloading {
                self?.moreFactsButton.isEnabled = false
                self?.moreFactsFromUserButton.isEnabled = false
                
            } else {
                self?.moreFactsButton.isEnabled = true
                self?.moreFactsFromUserButton.isEnabled = true
            }
            }).disposed(by: disposeBag)
    }
    
    private func setup() {
        moreFactsFromUserButton.isHidden = true
        print(moreFactsFromUserButton.isHidden)
        viewModel.requestData()
        view.addSubview(image)
        view.addSubview(catFactLabel)
        view.addSubview(moreFactsButton)
        view.addSubview(catFactAuthor)
        view.addSubview(moreFactsFromUserButton)
        
        image.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.height.equalTo(view.safeAreaLayoutGuide.layoutFrame.height/3)
        }
        
        catFactLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.top.equalTo(image.snp.bottom).offset(50)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-30)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(30)
        }
        
        moreFactsButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.width.equalTo(300)
        }
        catFactAuthor.snp.makeConstraints { make in
            make.top.equalTo(catFactLabel.snp.bottom).offset(5)
            make.trailing.equalTo(catFactLabel.snp.trailing)
            make.leading.equalTo(catFactLabel.snp.leading)
        }
        moreFactsFromUserButton.snp.makeConstraints { make in
            make.leading.equalTo(catFactLabel.snp.leading)
            make.top.equalTo(catFactLabel.snp.bottom)//.offset(5)
        }
    }
    
    // MARK: - Button Target
    @objc func buttonAction() {
        viewModel.publishRandomFact()
    }

    @objc func moreFromUserAction() {
        guard let factAuthor = catFactAuthor.text else { return }
        let userFactsView = UserFactsView()
        userFactsView.userFactsModel = UserFactsViewModel(user: factAuthor, dataModel: viewModel.catFactDataModel)
        self.navigationController?.pushViewController(userFactsView, animated: true)
    }
}
