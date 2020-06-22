//
//  UserFactsViewModel.swift
//  CatFacts
//
//  Created by Baur Versand on 16.06.20.
//  Copyright © 2020 Empiriecom. All rights reserved.
//

import RxSwift

class UserFactsViewModel {
    
    let selectedUser: String
    let catFactDataModel: CatFactDataModel
    let userFacts: BehaviorSubject<[FactModel]> = BehaviorSubject(value: [])
    let backgroundImage: BehaviorSubject<String> = BehaviorSubject(value: "")
    private let imageNames = ["cuteKitty4", "cuteKitty1", "cuteKitty2", "cuteKitty3"]
        
        init(user: String, dataModel: CatFactDataModel) {
            selectedUser = user
            catFactDataModel = dataModel
            loadUserFacts()
        }
        
        private func loadUserFacts() {
            userFacts.onNext(catFactDataModel.getFacts(ofUser: selectedUser))
            backgroundImage.onNext(selectRandomBGImage())
        }
        
        private func selectRandomBGImage() -> String {
            let name = imageNames[Int.random(in: 0 ..< imageNames.count)]
            return name
            
        }
    }

    /*
    init(user: String, dataModel: CatFactDataModel) {
        selectedUser = user
        catFactDataModel = dataModel
        loadUserFacts()
    }
    
    private func loadUserFacts() {
        userFacts.onNext(catFactDataModel.getFacts(ofUser: selectedUser))
    }
}
*/
