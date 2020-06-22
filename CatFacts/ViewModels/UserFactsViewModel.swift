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
    
    init(user: String, dataModel: CatFactDataModel) {
        selectedUser = user
        catFactDataModel = dataModel
        loadUserFacts()
    }
    
    private func loadUserFacts() {
        userFacts.onNext(catFactDataModel.getFacts(ofUser: selectedUser))
    }
}
