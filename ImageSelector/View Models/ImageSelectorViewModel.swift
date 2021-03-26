//
//  ImageSelectorViewModel.swift
//  ImageSelector
//
//  Created by Munachimso Ugorji on 26/03/2021.
//

import Foundation

class ImageSelectorViewModel {
    private var imageStrings: [String] = [String]()
    private var apiService: ApiService?
    private var arrayOfSelectedIndex: [Int] = [Int]()
    
    init(with apiService: ApiService?) {
        self.apiService = apiService
    }
    
    public func getPhotos(delegate: ApiServiceDelegate) {
        guard let apiService = self.apiService else { return }
        apiService.fetchPhotos(photosDelegate: delegate)
    }
    
    public func updateImageStrings(with response: [String]) {
        self.imageStrings.append(contentsOf: response)
    }
    
    public func getImageStringsCount() -> Int {
        return imageStrings.count
    }
    
    public func getImageCellViewModel(index: Int) -> ImageCellViewModel {
        return ImageCellViewModel(imageString: self.getSingleImageString(index: index))
    }
    
    public func getSingleImageString(index: Int) -> String {
        return self.imageStrings[index]
    }
    
    public func updateSelectedIndex(index: Int) {
        if arrayOfSelectedIndex.isEmpty || arrayOfSelectedIndex.last != index {
            arrayOfSelectedIndex.append(index)
        }
    }
    
    public func getLastImageIndex() -> Int? {
        return arrayOfSelectedIndex.last
    }
    
    public func getPreviousImageIndex() -> Int? {
        if arrayOfSelectedIndex.count >= 2 {
            return arrayOfSelectedIndex[arrayOfSelectedIndex.count - 2]
        }
        return nil
    }
}
