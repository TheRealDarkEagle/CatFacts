//
//  StartViewModel.swift
//  CatFacts
//
//  Created by Baur Versand on 15.06.20.
//  Copyright © 2020 Empiriecom. All rights reserved.
//

import RxSwift
import Alamofire

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
        AF.request("https://cat-fact.herokuapp.com/facts").responseJSON { response in
            switch response.result {
            case .success:
                do {
                    self.catFactDataModel.data = try JSONDecoder().decode(AllFacts.self, from: (response.data)!)
                } catch {
                    debugPrint("\(error)")
                }
            case .failure(let error):
                debugPrint(error)
            }
            self.isLoading.onNext(false)
            self.buttonText.on(.next("Drück mich für einen Cat-Fact!"))
        }
        
    }
    
    func publishRandomFact() {
        let fact = catFactDataModel.getRandomFact()
        catFact.on(.next(fact))
        buttonText.on(.next("Drück mich für den nächsten Fakt!"))
    }
}
