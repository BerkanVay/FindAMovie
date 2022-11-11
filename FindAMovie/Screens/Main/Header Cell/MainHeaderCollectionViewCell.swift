//
//  MainHeaderCollectionViewCell.swift
//  FindAMovie
//
//  Created by Mustafa Berkan Vay on 10.11.2022.
//

import UIKit

class MainHeaderCollectionViewCell: UICollectionViewCell {
  @IBOutlet private weak var backgroundImageView: UIImageView!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var overviewLabel: UILabel!
  
  private var movie: MoviePaginationResponse.Movie?
}

extension MainHeaderCollectionViewCell {
  func configure(withMovie movie: MoviePaginationResponse.Movie) {
    self.movie = movie
    
    ImageFetcher.load(toImageView: backgroundImageView, path: movie.backDropPath)
    
    titleLabel.text = "\(movie.title) (xxxx)"
    overviewLabel.text = movie.overview
  }
}
