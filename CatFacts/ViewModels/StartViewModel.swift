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
    
    var buttonText = PublishSubject<String>()
    var catFactText = PublishSubject<String>()
    var catFactPublisher = PublishSubject<String>()
    var isLoading = PublishSubject<Bool>()
    let catDataModel = CatDataModel()
    
    func requestData() {
        isLoading.on(.next(true))
        AF.request("https://cat-fact.herokuapp.com/facts").responseJSON { response in
            switch response.result {
            case .success(let data):
                
                self.catDataModel.data = JSON(data)
                /*
                let datas = json["all"].arrayValue[10]
                debugPrint(datas["user"])
                debugPrint(datas["text"])
                debugPrint(datas["upvotes"])
                self.timeText.on(.next("\(datas["text"])"))
                 */
                
            case .failure(let error):
                debugPrint(error)
            }
            self.isLoading.on(.next(false))
        }
        buttonText.on(.next("Klicke hier für einen Cat-Fact!"))
        catFactText.on(.next(""))
    }
    
    func randomFact() {
        print("gathering random Cat Fact...")
        let fact = catDataModel.getRandomFact()
        print("\(fact)")
        catFactText.on(.next("\(fact["text"])"))
        catFactPublisher.on(.next("\(fact["user"]["name"]["last"]) \(fact["user"]["name"]["first"])"))
    }
    
}
