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

class StartView: UIViewController {
    
    // MARK: - Properties
    var catFactLabel: UILabel = {
        var label = UILabel(frame: CGRect(x: 50, y: 50, width: 60, height: 100))
        label.text = ""
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.sizeToFit()
        label.backgroundColor = .cyan
        return label
    }()
    
    var image: UIImageView = {
        var image = UIImageView(image: UIImage(named: "babyKitty"))
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.cornerRadius = image.frame.height/4
        image.clipsToBounds = true
        return image
    }()
    
    var moreFactsButton: UIButton = {
        var button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 250, height: 30)
        button.backgroundColor  = .systemGray6
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
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
        viewModel.catFact.bind(to: catFactLabel.rx.text).disposed(by: disposeBag)
        viewModel.buttonText.subscribe(onNext: { [weak self] text in
            self?.moreFactsButton.setTitle(text, for: .normal)
            }).disposed(by: disposeBag)
    }
    
    private func setup() {
        viewModel.requestData()
        view.addSubview(image)
        view.addSubview(catFactLabel)
        view.addSubview(moreFactsButton)
        
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
        }
    }
    
    // MARK: - Button Target
    
    @objc func buttonAction() {
        viewModel.randomFact()
    }

}
