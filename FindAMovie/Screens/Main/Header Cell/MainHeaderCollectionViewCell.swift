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
}

extension MainHeaderCollectionViewCell {
  func configure(withMovie movie: MoviePaginationResponse.Movie) {
    ImageFetcher.load(toImageView: backgroundImageView, path: movie.backDropPath)
    
    let dateComponents = Calendar.current.dateComponents([.year], from: movie.releaseDate)
    titleLabel.text = "\(movie.title) (\(dateComponents.year ?? 0))"
    
    overviewLabel.text = movie.overview
  }
}
