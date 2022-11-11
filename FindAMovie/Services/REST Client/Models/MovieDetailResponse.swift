//
//  MovieDetailResponse.swift
//  FindAMovie
//
//  Created by Mustafa Berkan Vay on 10.11.2022.
//

import Foundation

struct MovieDetailResponse: Decodable {
  let imdbId: String
  let overview: String
  let voteAverage: Int
  let backDropPath: String
  let title: String
  
  enum CodingKeys: String, CodingKey {
    case imdbId = "imdb_id"
    case overview
    case voteAverage = "vote_average"
    case backDropPath = "backdrop_path"
    case title
  }
}
