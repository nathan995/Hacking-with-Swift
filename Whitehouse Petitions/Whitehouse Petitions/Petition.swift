//
//  Petition.swift
//  Whitehouse Petitions
//
//  Created by Nathan Getachew on 4/26/23.
//

import Foundation

struct Petition : Codable {
    
    var title: String?
    var body: String
    var signatureCount: Int
    
}

struct Petitions: Codable {
    
    var results: [Petition]
    
}
