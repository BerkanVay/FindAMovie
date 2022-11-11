//
//  MoviePaginationResponse.swift
//  FindAMovie
//
//  Created by Mustafa Berkan Vay on 10.11.2022.
//

import Foundation

struct MoviePaginationResponse: Decodable {
  let results: [Movie]
  
  struct Movie: Decodable, Hashable {
    private static let dateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "YYYY-MM-dd"
      return dateFormatter
    }()
    
    let id: Int
    let backDropPath: String
    let posterPath: String
    let title: String
    let overview: String
    private let releaseDateString: String
    let voteAverage: Double
    
    var releaseDate: Date {
      return Self.dateFormatter.date(from: releaseDateString) ?? Date()
    }
    
    enum CodingKeys: String, CodingKey {
      case id
      case backDropPath = "backdrop_path"
      case posterPath = "poster_path"
      case title
      case overview
      case releaseDateString = "release_date"
      case voteAverage = "vote_average"
    }
  }
}
