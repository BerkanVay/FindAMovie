//
//  MainViewModelDelegate.swift
//  FindAMovie
//
//  Created by Mustafa Berkan Vay on 11.11.2022.
//

import Foundation

protocol MainViewModelDelegate: AnyObject {
  func shouldReloadNowPlayings()
  func shouldReloadUpcomings()
}
