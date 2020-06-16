//
//  CatDataModel.swift
//  CatFacts
//
//  Created by Baur Versand on 15.06.20.
//  Copyright © 2020 Empiriecom. All rights reserved.
//

import Foundation
import SwiftyJSON

class CatFactDataModel {
    var data: JSON? {
        didSet {
            convertDataToModel()
        }
    }
    
    private var facts = [FactModel]()
    
    func getRandomFact() -> FactModel {
        if facts.count > 0 {
            return getFact(number: Int.random(in: 0 ..< facts.count))
        }
        return FactModel(author: "Admin", fact: "cant load facts... retry pls", identifier: "adminIsSayingThis")
    }
    
    private func getFact(number: Int) -> FactModel {
        facts[number]
    }
    
    private func convertDataToModel() {
         guard let dataArray = data?["all"].arrayValue else { return }
        dataArray.forEach { data in
            guard let lastName = data["user"]["name"]["last"].string,
                let firstName = data["user"]["name"]["first"].string,
                let factId = data["_id"].string,
                let fact = data["text"].string
            else { return }
            let factModel = FactModel(author: "\(lastName) \(firstName)", fact: fact, identifier: factId)
            facts.append(factModel)
        }
    }
    
    func getFacts(ofUser user: String) -> [FactModel] {
        facts.filter { fact -> Bool in
            if fact.author == user {
                return true
            } else {
                return false
            }
        }
    }
    
}
