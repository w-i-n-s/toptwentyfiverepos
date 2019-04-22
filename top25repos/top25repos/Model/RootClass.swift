//
//  RootClass.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on April 22, 2019

import Foundation

struct RootClass : Codable {

        let incompleteResults : Bool?
        let items : [Item]?
        let totalCount : Int?

        enum CodingKeys: String, CodingKey {
                case incompleteResults = "incomplete_results"
                case items = "items"
                case totalCount = "total_count"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                incompleteResults = try values.decodeIfPresent(Bool.self, forKey: .incompleteResults)
                items = try values.decodeIfPresent([Item].self, forKey: .items)
                totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
        }

}
