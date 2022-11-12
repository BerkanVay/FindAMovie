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
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.navigationBar.isHidden = false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.isHidden = true
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if let indexPathForSelectedRow = contentTableView.indexPathForSelectedRow {
      contentTableView.deselectRow(at: indexPathForSelectedRow, animated: true)
    }
  }
}

extension MainViewController {
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
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetailFromTableView" {
      guard
        let destination = segue.destination as? DetailViewController,
        let selectedIndex = self.contentTableView.indexPathForSelectedRow
      else { return }
      
      destination.configure(withMovieId: viewModel.upcomings[selectedIndex.row].id)
    } else if segue.identifier == "showDetailFromCollectionView" {
      guard
        let destination = segue.destination as? DetailViewController,
        let selectedIndex = self.headerCollectionView.indexPathsForSelectedItems?.first?.row
      else { return }
      
      destination.configure(withMovieId: viewModel.nowPlayings[selectedIndex].id)
    }
  }
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
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    // We only want to handle the collection view
    guard scrollView == headerCollectionView else { return }
    
    let index = Int(scrollView.contentOffset.x / headerCollectionView.bounds.width)
    
    pageControl.currentPage = index
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // We don't want to handle collection view's scroll view
    guard scrollView == self.scrollView else { return }
    
    if scrollView.contentSize.height - (scrollView.bounds.height + scrollView.contentOffset.y) < 250 {
      Task {
        await viewModel.fetchNextUpcomingPage()
      }
    }
  }
}
