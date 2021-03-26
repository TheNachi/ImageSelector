//
//  ViewController.swift
//  ImageSelector
//
//  Created by Munachimso Ugorji on 26/03/2021.
//

import UIKit

class ImageSelectorViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var NoImageSelectedLabel: UILabel!
    
    
    private var viewModel: ImageSelectorViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageCollectionView.dataSource = self
        self.imageCollectionView.delegate = self
        let apiService = ApiService()
        self.viewModel = ImageSelectorViewModel(with: apiService)
        self.bindViewModel(with: viewModel)
        
    }
    
    func bindViewModel(with viewModel: ImageSelectorViewModel?) {
        viewModel?.getPhotos(delegate: self)
    }

    @IBAction func onNewSegmentSelected(_ sender: UISegmentedControl) {
        guard let vModel = viewModel else { return }
        
        if sender.selectedSegmentIndex == 1 {
            if let index = vModel.getLastImageIndex(), let imageUrl = URL(string: vModel.getSingleImageString(index: index)) {
                self.NoImageSelectedLabel.isHidden = true
                imageView.load(url: imageUrl)
            } else {
                self.NoImageSelectedLabel.text = StringHelper.lastImageLabel.rawValue
                self.NoImageSelectedLabel.isHidden = false
            }
            self.imageCollectionView.isHidden = true
        } else if sender.selectedSegmentIndex == 2 {
            if let index = vModel.getPreviousImageIndex(), let imageUrl = URL(string: vModel.getSingleImageString(index: index)) {
                imageView.load(url: imageUrl)
                self.NoImageSelectedLabel.isHidden = true
            } else {
                self.imageView.image = nil
                self.NoImageSelectedLabel.text = StringHelper.previousImageLabel.rawValue
                self.NoImageSelectedLabel.isHidden = false
            }
            self.imageCollectionView.isHidden = true
        } else {
            if let index = vModel.getLastImageIndex(), let imageUrl = URL(string: vModel.getSingleImageString(index: index)) {
                self.NoImageSelectedLabel.isHidden = true
                imageView.load(url: imageUrl)
            } else {
                self.NoImageSelectedLabel.text = StringHelper.imageSelectorLabel.rawValue
            }
            self.imageCollectionView.isHidden = false
        }
    }
    
}

extension ImageSelectorViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let vModel = self.viewModel else { return 0 }
        return vModel.getImageStringsCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let vModel = self.viewModel else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath)
        
        if let imageCell = cell as? ImageCollectionViewCell {
            imageCell.bindViewModel(with: vModel.getImageCellViewModel(index: indexPath.row))
            return imageCell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vModel = self.viewModel else { return }
        self.NoImageSelectedLabel.isHidden = true
        if let imageUrl = URL(string: vModel.getSingleImageString(index: indexPath.row)) {
            imageView.load(url: imageUrl)
            vModel.updateSelectedIndex(index: indexPath.row)
        }
        
    }

}

extension ImageSelectorViewController: ViewControllerProtocol {
    func updateView() {
        DispatchQueue.main.async {
            self.imageCollectionView.reloadData()
        }
    }
}

extension ImageSelectorViewController: ApiServiceDelegate {
    func gotPhotos(photos: [String]) {
        guard let vModel = self.viewModel else { return }
        vModel.updateImageStrings(with: photos)
        self.updateView()
    }
    
    func failureToGetPhotos(error: Error) {
        print(error.localizedDescription)
    }
}

protocol ViewControllerProtocol {
    func updateView()
}


