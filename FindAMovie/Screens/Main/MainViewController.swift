//
//  MainViewController.swift
//  FindAMovie
//
//  Created by Mustafa Berkan Vay on 10.11.2022.
//

import UIKit

class MainViewController: UIViewController {
  @IBOutlet private weak var scrollView: UIScrollView!
  @IBOutlet private weak var headerCollectionView: UICollectionView!
  @IBOutlet private weak var pageControl: UIPageControl!
  @IBOutlet private weak var contentTableView: ContentSizedTableView!
  
  private let viewModel = MainViewModel()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel.delegate = self
    
    createRefreshControl()
  }
  
  private func createRefreshControl() {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refreshHappened), for: .valueChanged)
    
    scrollView.refreshControl = refreshControl
  }
  
  @objc private func refreshHappened() {
    Task {
      await viewModel.reload()
      
      scrollView.refreshControl?.endRefreshing()
    }
  }
}

extension MainViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.nowPlayings.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MainHeaderCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    cell.layoutSubviews()
    cell.configure(withMovie: viewModel.nowPlayings[indexPath.row])
    
    return cell
  }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    collectionView.bounds.size
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let index = Int(scrollView.contentOffset.x / headerCollectionView.bounds.width)
    
    pageControl.currentPage = index
  }
}

extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.upcomings.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MainTableViewCell else {
      return UITableViewCell()
    }
    cell.configure(withMovie: viewModel.upcomings[indexPath.row])
    
    return cell
  }
}

extension MainViewController: UITableViewDelegate {
  
}

extension MainViewController: MainViewModelDelegate {
  func shouldReloadNowPlayings() {
    DispatchQueue.main.async {
      self.headerCollectionView.reloadData()
    }
  }
  
  func shouldReloadUpcomings() {
    DispatchQueue.main.async {
      self.contentTableView.reloadData()
    }
  }
}

extension MainViewController {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentSize.height - (scrollView.bounds.height + scrollView.contentOffset.y) < 250 {
      Task {
        await viewModel.fetchNextUpcomingPage()
      }
    }
  }
}
