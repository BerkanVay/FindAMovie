//
//  DetailViewModel.swift
//  FindAMovie
//
//  Created by Mustafa Berkan Vay on 12.11.2022.
//

import Foundation

class DetailViewModel {
  weak var delegate: DetailViewModelDelegate?
  
  var movie: MovieDetailResponse? {
    didSet {
      delegate?.shouldReload()
    }
  }
  
  init(withMovieId movieId: Int) {
    Task {
      await fetchMovieDetail(movieId: movieId)
    }
  }
  
  private func fetchMovieDetail(movieId: Int) async {
    movie = try! await RESTClient.getMoviewDetail(id: movieId)
  }
}
