//
//  ImageFetcher.swift
//  FindAMovie
//
//  Created by Mustafa Berkan Vay on 10.11.2022.
//

import Foundation
import Kingfisher

class ImageFetcher {
  private static let baseURLString = "https://image.tmdb.org/t/p/w500/"
  
  static func load(toImageView imageView: UIImageView, path: String) {
    guard let baseURL = URL(string: baseURLString + path) else {
      // TODO: Handle the error.
      
      return
    }
    
    imageView.kf.setImage(with: baseURL)
  }
}
