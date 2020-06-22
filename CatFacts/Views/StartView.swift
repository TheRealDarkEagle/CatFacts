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

/* MARK: - TODO
    design anpassen für alle devices
    landscape to portrait mode implementieren (drehung "abfangen" und constraints neu auslegen)
    LieblingsFacts Speichern?
 */

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
    
    var catImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "babyKitty"))
        //image.layer.borderWidth = 2
        //image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.cornerRadius = image.frame.size.height / 6
        image.clipsToBounds = true
        //image.layer.masksToBounds = true
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
        button.setTitle("Tab für mehr Userfacts von:", for: .normal)
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
        viewModel.requestData()
        
        view.addSubview(catImage)
        view.addSubview(catFactLabel)
        view.addSubview(moreFactsButton)
        view.addSubview(catFactAuthor)
        view.addSubview(moreFactsFromUserButton)
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        if UIDevice.current.orientation.isPortrait {
            setPortraitModeConstraints()
        } else {
            setLandscapreModeConstraints()
        }
    }
    
    private func setLandscapreModeConstraints() {
        catImage.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).dividedBy(3).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(5)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(5)
        }
        catFactLabel.snp.remakeConstraints { make in
            make.top.equalTo(catImage.snp.top)
            make.leading.equalTo(catImage.snp.trailing).offset(5)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-5)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
        moreFactsButton.snp.remakeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(2)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-15)
            make.leading.equalTo(catImage.snp.trailing).offset(2)
        }
        catFactAuthor.snp.remakeConstraints { make in
            make.top.equalTo(catFactLabel.snp.bottom).offset(-5)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-5)
            make.bottom.lessThanOrEqualTo(moreFactsButton.snp.top)
        }
        moreFactsFromUserButton.snp.remakeConstraints { make in
            make.top.equalTo(catFactAuthor.snp.top)
            make.leading.equalTo(catImage.snp.trailing).offset(2)
            make.trailing.lessThanOrEqualTo(catFactAuthor.snp.leading).offset(-2)
            make.bottom.equalTo(catFactAuthor.snp.bottom)
        }
    }
    
    private func setPortraitModeConstraints() {
        catImage.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
            make.height.equalTo(250)
        }
        
        catFactLabel.snp.remakeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.top.equalTo(catImage.snp.bottom).offset(50)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-15)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(15)
        }
        
        moreFactsButton.snp.remakeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.width.equalTo(300)
        }
        catFactAuthor.snp.remakeConstraints { make in
            make.top.equalTo(catFactLabel.snp.bottom).offset(5)
            make.trailing.equalTo(catFactLabel.snp.trailing)
            make.leading.lessThanOrEqualTo(moreFactsFromUserButton.snp.trailing).offset(-10)
        }
        moreFactsFromUserButton.snp.remakeConstraints { make in
            make.leading.equalTo(catFactLabel.snp.leading)
            make.top.equalTo(catFactLabel.snp.bottom)
        }
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        view.setNeedsUpdateConstraints()
    }
    
    // MARK: - Button Actions
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
