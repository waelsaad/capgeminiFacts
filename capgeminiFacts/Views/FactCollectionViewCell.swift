//
//  FactCollectionViewCell.swift
//  capgeminiFacts
//
//  Created by Wael Saad on 6/4/18.
//  Copyright © 2018 nettrinity.com.au All rights reserved.
//

import UIKit
import SDWebImage

protocol ImageDownloaded {
    // Resize the image cell once its been downloaded
    func resizeCell(at index: Int, size: CGSize)
}

class FactCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate : ImageDownloaded!
    var viewModel : FactCellViewModel!
    
    func loadData(viewModel : FactCellViewModel, delegate: ImageDownloaded) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.titleLabel.text = self.viewModel.title
        if let url = viewModel.imageUrl {
            self.imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: APPIMAGES.NoImage), options: .allowInvalidSSLCertificates, completed: { (image, error, cacheType, url) in
                if let downloadedImage = image{
                    let size = CGSize(width: downloadedImage.size.width, height: downloadedImage.size.height + self.titleLabel.frame.height)
                    self.delegate.resizeCell(at: self.viewModel.index, size: size)
                }
            })
        }
        else
        {
            self.imageView.image = UIImage(named: APPIMAGES.NoImage)
        }
    }
}
