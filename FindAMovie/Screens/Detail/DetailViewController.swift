//
//  DetailViewController.swift
//  FindAMovie
//
//  Created by Mustafa Berkan Vay on 12.11.2022.
//

import UIKit

class DetailViewController: UIViewController {
  @IBOutlet private weak var posterImageView: UIImageView!
  @IBOutlet private weak var rateLabel: UILabel!
  @IBOutlet private weak var dotView: UIView!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var releaseDateLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!

  private static let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.YYYY"
    return dateFormatter
  }()
  
  private var viewModel: DetailViewModel?
  
  @IBAction func imdbButtonTapped(_ sender: Any) {
    guard let imdbId = viewModel?.movie?.imdbId else { return }
    guard let url = URL(string: "https://www.imdb.com/title/\(imdbId)") else { return }
    
    UIApplication.shared.open(url)
  }
}

extension DetailViewController {
  func configure(withMovieId movieId: Int) {
    viewModel = DetailViewModel(withMovieId: movieId)
    viewModel?.delegate = self
  }
}

extension DetailViewController: DetailViewModelDelegate {
  func shouldReload() {
    guard let movie = viewModel?.movie else { return }
    
    DispatchQueue.main.async {
      let dateComponents = Calendar.current.dateComponents([.year], from: movie.releaseDate)
      self.title = "\(movie.title) (\(dateComponents.year ?? 0))"
      
      ImageFetcher.load(toImageView: self.posterImageView, path: movie.backDropPath)
      
      self.titleLabel.text = self.title
      self.rateLabel.text = String(format: "%.1f", movie.voteAverage)
      self.dotView.layer.cornerRadius = self.dotView.bounds.width / 2
      self.releaseDateLabel.text = Self.dateFormatter.string(from: movie.releaseDate)
      self.descriptionLabel.text = movie.overview
    }
  }
}
