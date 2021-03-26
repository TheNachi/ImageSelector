//
//  ApiService.swift
//  ImageSelector
//
//  Created by Munachimso Ugorji on 26/03/2021.
//

import Foundation

struct ApiManager {
    private let imageUrl = StringHelper.baseUrl.rawValue
    weak var delegate: ApiManagerDelegate?
    
    func fetchPhotos(photosDelegate: ApiManagerDelegate) {
        if let url = URL(string: imageUrl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    photosDelegate.failureToGetPhotos(error: error!)
                    return
                }
                
                if let photosData = data {
                    if let imageArray = self.parseJSON(photosData) {
                        photosDelegate.gotPhotos(photos: imageArray)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ imageData: Data) -> [String]? {
        let decoder = JSONDecoder()
        do {
            let imageArray = try decoder.decode([String].self, from: imageData)
            return imageArray
        } catch {
            self.delegate?.failureToGetPhotos(error: error)
            return nil
        }
    }
}

protocol ApiManagerDelegate: class {
    func gotPhotos(photos: [String])
    func failureToGetPhotos(error: Error)
}
