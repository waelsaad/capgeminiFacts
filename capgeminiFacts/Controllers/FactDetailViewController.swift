//
//  FactDetailViewController.swift
//  capgeminiFacts
//
//  Created by Wael Saad on 6/4/18.
//  Copyright © 2018 nettrinity.com.au All rights reserved.
//

import UIKit
import SDWebImage

class FactDetailViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var topImageView: UIImageView!
    var viewModel : FactCellViewModel!
    
    func loadData(vm: FactCellViewModel) {
        viewModel = vm
    }
    // Use SDWebimage to cache images
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = viewModel.desc
        if let url = viewModel.imageUrl {
            self.topImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: APPIMAGES.NoImage))
        }
        else {
            self.topImageView.image = UIImage(named: APPIMAGES.NoImage)
        }
        self.title = viewModel.title
    }
    
    // As iPad Traits doesnt change, so explicitly changing it so that landscape and portrait requirement can be met.
    // It was either this or updating constraints like in commit before this one
    override var traitCollection: UITraitCollection {
        if UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isLandscape {
            return UITraitCollection(traitsFrom:[UITraitCollection(horizontalSizeClass: .regular), UITraitCollection(verticalSizeClass: .compact)])
        }
        return super.traitCollection
    }
}

