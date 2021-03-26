//
//  ImageCollectionViewCell.swift
//  ImageSelector
//
//  Created by Munachimso Ugorji on 26/03/2021.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    static let identifier = StringHelper.imageCell.rawValue
    @IBOutlet weak var imageView: UIImageView!
    
    func bindViewModel(with viewModel: ImageCellViewModel) {
        if let imageUrl = URL(string: viewModel.imageString) {
            imageView.load(url: imageUrl)
        }
    }
}

struct ImageCellViewModel {
    let imageString: String
}
