//
//  CatDataModel.swift
//  CatFacts
//
//  Created by Baur Versand on 15.06.20.
//  Copyright © 2020 Empiriecom. All rights reserved.
//

import Foundation
import SwiftyJSON

class CatDataModel {
    var data: JSON?
    
    func getRandomFact() -> JSON {
        guard let dataArray = data?["all"].arrayValue else { return JSON() }
        return dataArray[Int.random(in: 0 ..< dataArray.count)]
    }
}
