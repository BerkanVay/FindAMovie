//
//  MainViewModel.swift
//  FindAMovie
//
//  Created by Mustafa Berkan Vay on 11.11.2022.
//

import Foundation

class MainViewModel {
  weak var delegate: MainViewModelDelegate?
  
  private(set) var nowPlayings: [MoviePaginationResponse.Movie] = [] {
    didSet {
      delegate?.shouldReloadNowPlayings()
    }
  }
  
  private(set) var upcomings: [MoviePaginationResponse.Movie] = [] {
    didSet {
      delegate?.shouldReloadUpcomings()
    }
  }
  
  private var pageNumber = 1
  private var isBusy = false
  
  init() {
    Task {
      await reload()
    }
  }
  
  func fetchNextUpcomingPage() async {
    if isBusy {
      return
    }
    
    isBusy = true
    pageNumber += 1
    upcomings += try! await RESTClient.getUpcomings(pageNumber: pageNumber).results
    isBusy = false
  }
  
  func reload() async {
    // Execute tasks in parallel
    _ = await [fetchNowPlaying(), fetchUpcomings()]
  }
  
  private func fetchNowPlaying() async {
    nowPlayings = Array(try! await RESTClient.getNowPlaying().results.prefix(5))
  }
  
  private func fetchUpcomings() async {
    pageNumber = 1
    upcomings = try! await RESTClient.getUpcomings(pageNumber: pageNumber).results
  }
}
