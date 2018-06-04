//
//  FactViewModel.swift
//  capgeminiFacts
//
//  Created by Wael Saad on 6/4/18.
//  Copyright © 2018 nettrinity.com.au All rights reserved.
//

import Foundation

protocol NetworkResponse {
    func stateUpdated(success : Bool, error: String)
}


class FactViewModel {
    
    var numberOfCells : Int { return facts.count }
    private let webservice :FactWebservice
    var facts  = Array<Fact>.init()
    private var selectedCell : Int?
    private let delegate: NetworkResponse
    
    func viewModelForCell(at index: Int) -> FactCellViewModel {
        return FactCellViewModel(fact: facts[index], index: index)
    }
    
    func cellSelected(index: Int) {
        selectedCell = index
    }
    
    func selectedViewModel() -> FactCellViewModel {
        return viewModelForCell(at: selectedCell!)
    }
    
    init(delegate : NetworkResponse) {
        self.delegate = delegate
        webservice = FactWebservice.init()
    }
    
    // Fetch the images
    func refreshData() {
        webservice.getData { (result) in
            switch result{
            case .response(let data):
                self.facts = data
                self.delegate.stateUpdated(success: true, error: "")
                break
            case .error(error: let error):
                self.facts.removeAll()
                self.delegate.stateUpdated(success: false, error: error.localizedDescription)
                break
            }
        }
    }
}
