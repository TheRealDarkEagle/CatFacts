//
//  StartViewModel.swift
//  CatFacts
//
//  Created by Baur Versand on 15.06.20.
//  Copyright © 2020 Empiriecom. All rights reserved.
//

import RxSwift
import Alamofire
import PromiseKit

// MARK: - Umabauen zu Klasse

struct StartViewModel {
    // MARK: - Parameter
    var catFact = PublishSubject<FactModel>()
    var buttonText = PublishSubject<String>()
    let catFactDataModel = CatFactDataModel()
    var isLoading = PublishSubject<Bool>()
    
    // MARK: - RequestData Function
    func requestData() {
        isLoading.onNext(true)
        buttonText.onNext("Just a Sec. Loading Data!")
       
        requestDataOfAPI().done { facts in
            self.catFactDataModel.data = facts
            self.isLoading.onNext(false)
            self.buttonText.on(.next("Drück mich für einen Cat-Fact!"))
        }
    }
    
    private func requestDataOfAPI() -> Promise<AllFacts> {
        return Promise { seal in
            AF.request("https://cat-fact.herokuapp.com/facts").responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let data = try JSONDecoder().decode(AllFacts.self, from: (response.data)!)
                        seal.fulfill(data)
                    } catch {
                        seal.reject(error)
                        debugPrint("\(error)")
                    }
                case .failure(let error):
                    debugPrint(error)
                    seal.reject(error)
                }
            }
        }
    }
    
    func publishRandomFact() {
        let fact = catFactDataModel.getRandomFact()
        catFact.on(.next(fact))
        buttonText.onCompleted()
    }
}
