//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import UIKit
import WebKit


class HomeDetailViewController: UIViewController {

  private let webview = WKWebView()
  private let activityIndicator = UIActivityIndicatorView(style: .gray)
  private let viewModel: HomeDetailViewModel
  
  init(homeDetailVM: HomeDetailViewModel) {
    self.viewModel = homeDetailVM
    super.init(nibName: nil, bundle: nil)
    setupConstraints()
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupConstraints() {
    view.add(subviews: [webview])
    webview.topAnchor.nail(.equal, to: view.safeAreaLayoutGuide.topAnchor, with: 0)
    webview.bottomAnchor.nail(.equal, to: view.safeAreaLayoutGuide.bottomAnchor, with: 0)
    webview.leadingAnchor.nail(.equal, to: view.safeAreaLayoutGuide.leadingAnchor, with: 0)
    webview.trailingAnchor.nail(.equal, to: view.safeAreaLayoutGuide.trailingAnchor, with: 0)
    
    view.add(subviews: [activityIndicator])
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    activityIndicator.transform = CGAffineTransform(scaleX: 1.75, y: 1.75)
    activityIndicator.centerXAnchor.nail(.equal, to: view.centerXAnchor, with: 0)
    activityIndicator.centerYAnchor.nail(.equal, to: view.centerYAnchor, with: 0)
  }
  
  private func setupView() {
    view.backgroundColor = .white
    webview.backgroundColor = .white
    setupWebview()
  }
  
  private func setupWebview() {
    webview.navigationDelegate = self
  }
  
  private func startActivityIndicator() {
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
  }
  
  private func stopActivityIndicator() {
    if activityIndicator.isAnimating {
      activityIndicator.stopAnimating()
      activityIndicator.isHidden = true
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    webview.load(viewModel.urlRequest)
    startActivityIndicator()
  }
}

extension HomeDetailViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    stopActivityIndicator()
  }
  
  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    stopActivityIndicator()
  }
}
