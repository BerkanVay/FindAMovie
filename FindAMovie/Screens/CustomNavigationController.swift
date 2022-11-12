//
//  CustomNavigationController.swift
//  FindAMovie
//
//  Created by Mustafa Berkan Vay on 12.11.2022.
//

import UIKit

class CustomNavigationController: UINavigationController {
  override var preferredStatusBarStyle: UIStatusBarStyle {
    topViewController?.preferredStatusBarStyle ?? .default
  }
}
