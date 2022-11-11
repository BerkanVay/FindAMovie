//
//  MainViewController.swift
//  FindAMovie
//
//  Created by Mustafa Berkan Vay on 10.11.2022.
//

import UIKit

class MainViewController: UIViewController {
  @IBOutlet private weak var headerCollectionView: UICollectionView!
  @IBOutlet private weak var pageControl: UIPageControl!
  
  enum HeaderSection: Int, CaseIterable {
      case general
  }
  
  private lazy var dataSource = UICollectionViewDiffableDataSource<HeaderSection, MoviePaginationResponse.Movie>(collectionView: headerCollectionView) { [weak self] collectionView, indexPath, movie in
    guard
      let self,
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MainHeaderCollectionViewCell
    else {
      return UICollectionViewCell()
    }
     
    cell.layoutSubviews()
    cell.configure(withMovie: movie)
    
    return cell
  }
  
  private var headerMovies: [MoviePaginationResponse.Movie] = []

  override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    registerHeaderDataSource()
    registerHeaderDelegate()
    
    Task {
      let response = try! await RESTClient.getNowPlaying()
      
      let movies = response.results
      
      DispatchQueue.main.async {
        var snapshot = NSDiffableDataSourceSnapshot<HeaderSection, MoviePaginationResponse.Movie>()
        snapshot.appendSections([.general])
        snapshot.appendItems(Array(movies.prefix(5)), toSection: .general)
        
        self.dataSource.apply(snapshot)
      }
    }
  }
}

extension MainViewController {
  private func registerHeaderDataSource() {
    headerCollectionView.dataSource = dataSource
  }
  
  private func registerHeaderDelegate() {
    headerCollectionView.delegate = self
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
    31
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = "sea"
    
    return cell
  }
}
