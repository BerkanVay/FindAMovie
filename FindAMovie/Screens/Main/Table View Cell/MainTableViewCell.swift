//
//  MainTableViewCell.swift
//  FindAMovie
//
//  Created by Mustafa Berkan Vay on 11.11.2022.
//

import UIKit

class MainTableViewCell: UITableViewCell {
  private static let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.YYYY"
    return dateFormatter
  }()
  
  @IBOutlet private weak var posterImageView: UIImageView!
  @IBOutlet private weak var movieTitleLabel: UILabel!
  @IBOutlet private weak var movieDescriptionLabel: UILabel!
  @IBOutlet private weak var movieReleaseDateLabel: UILabel!
  
  func configure(withMovie movie: MoviePaginationResponse.Movie) {
    ImageFetcher.load(toImageView: posterImageView, path: movie.posterPath)
    movieTitleLabel.text = movie.title
    movieDescriptionLabel.text = movie.overview
    movieReleaseDateLabel.text = Self.dateFormatter.string(from: movie.releaseDate)
  }
}
