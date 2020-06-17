//
//  FactModel.swift
//  CatFacts
//
//  Created by Baur Versand on 16.06.20.
//  Copyright © 2020 Empiriecom. All rights reserved.
//

// MARK: - FactModel
struct FactModel: Decodable {
    let author, fact, identifier: String
}

// MARK: - AllFacts
struct AllFacts: Codable {
    let all: [Fact]
}

// MARK: - Fact
struct Fact: Codable {
    let identifier, text: String
    let user: User?

    enum CodingKeys: String, CodingKey {
        case identifier = "_id"
        case text, user
    }
}

// MARK: - User
struct User: Codable {
    let name: Name
}

// MARK: - Name
struct Name: Codable {
    let first, last: String
}
