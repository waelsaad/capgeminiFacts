//
//  Facts.swift
//  capgeminiFacts
//
//  Created by Wael Saad on 6/4/18.
//  Copyright © 2018 nettrinity.com.au All rights reserved.
//

import Foundation

// Json Object
struct Fact {
    let title: String
    let description: String?
    let imageHref: String?
    
    // Parse the JSON 
    init(jsonDictionary: [String: Any]) {
        self.title = (jsonDictionary["title"] as? String)!
        self.description = (jsonDictionary["description"] as? String) ?? nil
        self.imageHref = (jsonDictionary["imageHref"] as? String) ?? nil
    }
}
