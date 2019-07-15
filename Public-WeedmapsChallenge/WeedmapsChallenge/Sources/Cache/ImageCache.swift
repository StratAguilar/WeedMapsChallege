//
//  ImageCache.swift
//  WeedmapsChallenge
//
//  Created by Strat Aguilar on 7/13/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import UIKit
import Alamofire


class ImageCache {
  
  static var sharedInstance = ImageCache()
  
  private var imageDictionary: [String: UIImage] = [:]
  
  private init() {}
  
  func add(image: UIImage, withURLString urlString: String) {
    imageDictionary[urlString] = image
    NotificationCenter.default.addObserver(self, selector: #selector(clearCache), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
  }
  
  func add(image: UIImage, withURL URL: URL) {
    add(image: image, withURLString: URL.absoluteString)
  }
  
  func getImage(withURLString URLString: String) -> UIImage? {
    return imageDictionary[URLString]
  }
  
  func getImage(withURL URL: URL) -> UIImage? {
    return getImage(withURLString: URL.absoluteString)
  }
  
  @objc func clearCache() {
    imageDictionary.removeAll()
  }
  
}

enum ImageCacheFetchError: Error {
  case invalidURL
  case invalidData
  case requestFailure
}

class ImageCacheFetchService {
  private let imageCache = ImageCache.sharedInstance
  private var currentImageViewFetchDictionary: [String: UIImageView] = [:]
  
  private func getImage(fromURL imageURL: URL?, completion: @escaping ((Result<UIImage>) -> Void)) {
    guard let imageURL = imageURL else {
      completion(.failure(ImageCacheFetchError.invalidURL))
      return
    }
    
    if let image = imageCache.getImage(withURL: imageURL) {
      completion(.success(image))
    } else {
      Alamofire.request(imageURL)
        .validate(statusCode: 200..<300)
        .responseData { (response) in
          DispatchQueue.main.async {
            switch response.result {
            case .success(let data):
              guard let image = UIImage(data: data) else {
                completion(.failure(ImageCacheFetchError.invalidData))
                return
              }
              self.imageCache.add(image: image, withURL: imageURL)
              completion(.success(image))
            case .failure(_):
              completion(.failure(ImageCacheFetchError.requestFailure))
            }
          }
      }
    }
  }
  
  private func clear(imageView: UIImageView) {
    imageView.image = nil
  }
  
  func getImage(fromURL imageURL: URL?, imageView: UIImageView) {
    clear(imageView: imageView)
    guard let imageURL = imageURL else { return }
    currentImageViewFetchDictionary[imageURL.absoluteString] = imageView
    getImage(fromURL: imageURL) { (result) in
      switch result {
      case .success(let image):
        if self.currentImageViewFetchDictionary[imageURL.absoluteString] == imageView {
          self.currentImageViewFetchDictionary.removeValue(forKey: imageURL.absoluteString)
          imageView.image = image
        }
      case .failure(let error):
        self.currentImageViewFetchDictionary.removeValue(forKey: imageURL.absoluteString)
        print(error)
      }
    }
  }
}
