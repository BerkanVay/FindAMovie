//
//  MoviePaginationResponse.swift
//  FindAMovie
//
//  Created by Mustafa Berkan Vay on 10.11.2022.
//

import Foundation

struct MoviePaginationResponse: Decodable {
  let results: [Movie]
  
  struct Movie: Decodable {
    let id: Int
    let backDropPath: String
    let posterPath: String
    let title: String
    let overview: String
    let releaseDate: String
    let voteAvarange: Double
    
    enum CodingKeys: String, CodingKey {
      case id
      case backDropPath = "backdrop_path"
      case posterPath = "poster_path"
      case title
      case overview
      case releaseDate = "release_date"
      case voteAvarange = "vote_average"
    }
  }
}
