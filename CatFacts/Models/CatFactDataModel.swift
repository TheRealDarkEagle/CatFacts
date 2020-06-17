//
//  CatDataModel.swift
//  CatFacts
//
//  Created by Baur Versand on 15.06.20.
//  Copyright © 2020 Empiriecom. All rights reserved.
//

import Foundation

class CatFactDataModel {
    var data: AllFacts? {
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
        guard let convertibaleData = data?.all else { return }
        convertibaleData.forEach { fact in
            var author = ""
            if let user = fact.user {
                author = "\(user.name.last) \(user.name.first)"
            }
            facts.append(FactModel(author: author, fact: fact.text, identifier: fact.identifier))
            
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
