//
//  MovieDetailResponse.swift
//  FindAMovie
//
//  Created by Mustafa Berkan Vay on 10.11.2022.
//

import Foundation

struct MovieDetailResponse: Decodable {
  private static let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd"
    return dateFormatter
  }()
  
  let imdbId: String
  let overview: String
  let voteAverage: Double
  let backDropPath: String
  let title: String
  private let releaseDateString: String
  
  var releaseDate: Date {
    Self.dateFormatter.date(from: releaseDateString) ?? Date()
  }
  
  enum CodingKeys: String, CodingKey {
    case imdbId = "imdb_id"
    case overview
    case voteAverage = "vote_average"
    case backDropPath = "backdrop_path"
    case title
    case releaseDateString = "release_date"
  }
}
