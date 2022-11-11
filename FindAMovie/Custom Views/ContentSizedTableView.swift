//
//  ContentSizedTableView.swift
//  FindAMovie
//
//  Created by Mustafa Berkan Vay on 11.11.2022.
//

import UIKit

final class ContentSizedTableView: UITableView {
  override var contentSize: CGSize {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }
  
  override var intrinsicContentSize: CGSize {
    layoutIfNeeded()
    
    return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
  }
}
