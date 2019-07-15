//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
  
  // MARK: Properties
  
  @IBOutlet private var collectionView: UICollectionView!
  
  private let searchBar = UISearchBar(frame: .zero)
  private let viewModel = HomeViewModel(requestService: BussinessApiRequest(config: APIRequestConfiguration()))
  private let imageCacheFetchService = ImageCacheFetchService()
  private let locationService = LocationService()
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setNavBar()
    setupCollectionView()
    fetchData(isNewFetch: true)
  }
  
  private func setNavBar() {
    navigationItem.titleView = searchBar
    searchBar.delegate = self
    searchBar.isAccessibilityElement = true
    searchBar.accessibilityIdentifier = "main search bar"
  }
  
  private func setup() {
    viewModel.setup(locationService: locationService)
  }
  private func setupCollectionView() {
    collectionView.registerCell(BusinessDisplayCollectionViewCell.self)
    collectionView.delegate = self
    collectionView.dataSource = self
    
    let defaultLayout = UICollectionViewFlowLayout()
    defaultLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    defaultLayout.scrollDirection = .vertical
    defaultLayout.itemSize = BusinessDisplayCollectionViewCell.suggestedSize
    collectionView.collectionViewLayout = defaultLayout
    
    collectionView.backgroundColor = WMStyle.Color.backgroundColor
    collectionView.isAccessibilityElement = true
    collectionView.accessibilityIdentifier = "homePageCollectionView"
  }
  
  private func fetchData(isNewFetch: Bool = false) {
    viewModel.FetchBusinessList(isNewFetch: isNewFetch) { (result) in
      switch result {
      case .success(let shouldUpdateView):
        if isNewFetch {
          self.searchBar.placeholder = self.viewModel.searchTerm
          self.collectionView.setContentOffset(.zero, animated: false)
        }
        if shouldUpdateView {
          self.collectionView.reloadData()
        }
      case .failure(let error):
        print(error)
      }
    }
  }
}

// MARK: UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    guard let url = viewModel.getBusinessPageURL(forIndex: indexPath.row) else {
      let alert = UIAlertController(title: "No Yelp Page", message: "There is no yelp page for this business", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alert.addAction(okAction)
      self.present(alert, animated: true, completion: nil)
      return
    }
    
    let alert = UIAlertController(title: "Business's Yelp Page", message: nil, preferredStyle: .actionSheet)
    
    let safariItem = UIAlertAction(title: "Open in Safari", style: .default) { (alert) in
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    let webviewItem = UIAlertAction(title: "Open in App", style: .default) { (alert) in
      let vm = HomeDetailViewModel(url: url)
      let homeDetailVC = HomeDetailViewController(homeDetailVM: vm)
      self.navigationController?.pushViewController(homeDetailVC, animated: true)
    }
    let cancelItem = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(webviewItem)
    alert.addAction(safariItem)
    alert.addAction(cancelItem)
    
    /*
    Know issue for "Unable to simultaneously satisfy constraints." When presenting AlertController as ActionSheet https://stackoverflow.com/questions/55372093/uialertcontrollers-actionsheet-gives-constraint-error-on-ios-12-2-12-3
    */
    self.present(alert, animated: true, completion: nil)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if !viewModel.fetchedEndOfList {
      let offsetY = scrollView.contentOffset.y
      let contentHeight = scrollView.contentSize.height
      guard offsetY > contentHeight - scrollView.frame.size.height * 3 else { return }
      fetchData()
    }
  }
  
  func presentSearchVC() {
    let vm = SearchViewModel(
      suggestionsRequestService: SuggestionRequestService(
      configurationService: APIRequestConfiguration()),
      locationService: locationService,
      searchHistoryCacheService: SearchHistoryCache())
    
    let searchVC = SearchViewController(viewModel: vm) { [weak self] newSearchText in
      guard let self = self, let newSearchText = newSearchText else { return }
      self.viewModel.searchTerm = newSearchText
      self.fetchData(isNewFetch: true)
    }
    let nav = UINavigationController(rootViewController: searchVC)
    self.present(nav, animated: true, completion: nil)
  }
}

// MARK: UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.businessCount
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(BusinessDisplayCollectionViewCell.self, for: indexPath)
    guard let object = viewModel.getBusinssInfo(forIndex: indexPath.row) else {
      return cell
    }
    cell.setup(object: object, imageFetchService: imageCacheFetchService)
    cell.backgroundColor = .white
    
    return cell
  }
}

extension HomeViewController: UISearchBarDelegate {
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    presentSearchVC()
    return false
  }
}

