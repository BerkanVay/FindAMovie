//
//  MainTableViewCell.swift
//  FindAMovie
//
//  Created by Mustafa Berkan Vay on 11.11.2022.
//

import UIKit

class MainTableViewCell: UITableViewCell {
  @IBOutlet private weak var posterImageView: UIImageView!
  @IBOutlet private weak var movieTitleLabel: UILabel!
  @IBOutlet private weak var movieDescriptionLabel: UILabel!
  
  private var movie: MoviePaginationResponse.Movie?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configure(withMovie movie: MoviePaginationResponse.Movie) {
    ImageFetcher.load(toImageView: posterImageView, path: movie.posterPath)
    movieTitleLabel.text = movie.title
    movieDescriptionLabel.text = movie.overview
  }
}
