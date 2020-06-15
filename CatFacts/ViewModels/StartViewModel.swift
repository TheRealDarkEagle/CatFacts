//
//  StartViewModel.swift
//  CatFacts
//
//  Created by Baur Versand on 15.06.20.
//  Copyright © 2020 Empiriecom. All rights reserved.
//

import RxSwift
import Alamofire
import SwiftyJSON

struct StartViewModel {
    // MARK: - Parameter
    var buttonText = PublishSubject<String>()
    var catFactText = PublishSubject<String>()
    var catFactPublisher = PublishSubject<String>()
    var isLoading = PublishSubject<Bool>()
    let catDataModel = CatDataModel()
    
    // MARK: - RequestData Function
    func requestData() {
        isLoading.on(.next(true))
        AF.request("https://cat-fact.herokuapp.com/facts").responseJSON { response in
            switch response.result {
            case .success(let data):
                self.catDataModel.data = JSON(data)
            case .failure(let error):
                debugPrint(error)
            }
            self.isLoading.on(.next(false))
        }
        buttonText.on(.next("Klicke hier für einen Cat-Fact!"))
    }
    
    func randomFact() {
        let fact = catDataModel.getRandomFact()
        catFactText.on(.next(getFactText(ofFact: fact)))
        catFactPublisher.on(.next(getPublisher(ofFact: fact)))
    }
    
    // MARK: - Helper Functions
    
    private func getPublisher(ofFact fact: JSON) -> String {
        guard let lastName = fact["user"]["name"]["last"].string,
              let firstName = fact["user"]["name"]["first"].string
        else { return "" }
        return "\(lastName) \(firstName)"
    }
    private func getFactText(ofFact fact: JSON) -> String {
        "\(fact["text"])"
    }
    
}
