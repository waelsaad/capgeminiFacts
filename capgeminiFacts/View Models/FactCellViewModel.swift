//
//  FactCellViewModel.swift
//  capgeminiFacts
//
//  Created by Wael Saad on 6/4/18.
//  Copyright © 2018 nettrinity.com.au All rights reserved.
//

import Foundation

class FactCellViewModel {
    
    let fact : Fact
    
    let title: String
    let desc: String
    let imageUrl: String?
    let index: Int
    
    init(fact: Fact, index: Int) {
        self.fact = fact
        self.index = index
        title = fact.title
        desc = fact.description ?? FactDescriptionText.NoDescription
        imageUrl = fact.imageHref
    }
}
