//
//  RESTClient.swift
//  FindAMovie
//
//  Created by Mustafa Berkan Vay on 10.11.2022.
//

import Foundation

class RESTClient {
  private static let apiKey = "1c953e71358b725a5c304d313217af14"
  private static let baseURLString = "https://api.themoviedb.org/3"
  
  enum NetworkingError: Error {
    case invalidURL
  }
  
  private static var jsonDecoder = JSONDecoder()
  
  static func getNowPlaying() async throws -> MoviePaginationResponse {
    try await doRequest(withEndpoint: "/movie/now_playing")
  }
  
  static func getUpcomings(pageNumber: Int) async throws -> MoviePaginationResponse {
    try await doRequest(withEndpoint: "/movie/upcoming", queryParameters: ["page" : "\(pageNumber)"])
  }
  
  static func getMoviewDetail(id: Int) async throws -> MovieDetailResponse {
    try await doRequest(withEndpoint: "/movie/\(id)")
  }
  
  private static func doRequest<T: Decodable>(withEndpoint endpoint: String, queryParameters: [String: String] = [:]) async throws -> T {
    guard var urlComponents = URLComponents(string: baseURLString) else {
      throw NetworkingError.invalidURL
    }
    
    urlComponents.path = endpoint
    
    urlComponents.queryItems = queryParameters.map { (key, value) in
      URLQueryItem(name: key, value: value)
    }
    
    urlComponents.queryItems?.append(URLQueryItem(name: "apikey", value: apiKey))
    
    guard let url = urlComponents.url else {
      throw NetworkingError.invalidURL
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    
    return try jsonDecoder.decode(T.self, from: data)
  }
}
