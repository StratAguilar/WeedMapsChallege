//
//  SearchViewController.swift
//  WeedmapsChallenge
//
//  Created by Strat Aguilar on 7/14/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
  
  let viewModel: SearchViewModel
  let tableView = UITableView()
  private let searchBar = UISearchBar(frame: .zero)
  internal var isKeyboardShowing: Bool = false
  fileprivate var keyboardFrame: CGRect?
  internal var originalInsets: UIEdgeInsets = .zero
  
  let completion: ((String?) -> Void)
  
  init(viewModel: SearchViewModel, completion: @escaping ((String?) -> Void)) {
    self.viewModel = viewModel
    self.completion = completion
    super.init(nibName: nil, bundle: nil)
    setupContraints()
    setupView()
    setupNavBar()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupContraints() {
    view.add(subviews: [tableView])
    tableView.topAnchor.nail(.equal, to: view.safeAreaLayoutGuide.topAnchor, with: 0)
    tableView.bottomAnchor.nail(.equal, to: view.safeAreaLayoutGuide.bottomAnchor, with: 0)
    tableView.leadingAnchor.nail(.equal, to: view.safeAreaLayoutGuide.leadingAnchor, with: 0)
    tableView.trailingAnchor.nail(.equal, to: view.safeAreaLayoutGuide.trailingAnchor, with: 0)
  }
  
  private func setupView() {
    view.backgroundColor = .white
    setupTableView()
  }
  
  private func setupNavBar() {
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
    navigationItem.rightBarButtonItem = cancelButton
    
    navigationItem.titleView = searchBar
    searchBar.delegate = self
    
  }
  
  private func setupTableView() {
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  @objc func dismissSelf(withCompletion: Bool = false) {
    if withCompletion {
      viewModel.addCurrentHistoryText()
    }
    
    hideKeyboard()
    self.dismiss(animated: true) { [weak self] in
      if withCompletion {
        self?.completion(self?.viewModel.currentSearchTerm)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    fetchLocation()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupKeyboardObservers()
    searchBar.becomeFirstResponder()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    viewModel.saveHistory()
    destroyKeyboardObservers()
    hideKeyboard()
  }
  
  func hideKeyboard() {
    searchBar.endEditing(true)
  }
  
  private func fetchLocation() {
    viewModel.fetchLocation { (result) in
      switch result {
      case .success(_): break
      case .failure(_): break
      }
    }
  }
}

extension SearchViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberOfSections
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sectionItem = viewModel.getSection(forIndex: section) else { return 0 }
    return viewModel.numberOfRows(forSection: sectionItem)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    if let sectionItem = viewModel.getSection(forIndex: indexPath.section){
      cell.textLabel?.text = viewModel.getTitle(forSection: sectionItem, withIndex: indexPath.row)
    }
    return cell
  }
}

extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard let sectionItem = viewModel.getSection(forIndex: section) else { return nil }
    return viewModel.getTitle(forSection: sectionItem)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let sectionItem = viewModel.getSection(forIndex: indexPath.section) else { return }
    let title = viewModel.getTitle(forSection: sectionItem, withIndex: indexPath.row)
    viewModel.currentSearchTerm = title
    dismissSelf(withCompletion: true)
  }
  
  @objc private func fetchSuggestions() {
    guard let searchTerm = viewModel.currentSearchTerm else { return }
    viewModel.fetchSuggestion(withSearchTerm: searchTerm) { (result) in
      switch result {
      case .success(let shouldUpdate):
        if shouldUpdate {
          self.tableView.reloadData()
        }
      case .failure(let error):
        print(error)
      }
    }
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    viewModel.currentSearchTerm = searchText
    
    NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.fetchSuggestions), object: nil)
    self.perform(#selector(self.fetchSuggestions), with: nil, afterDelay: 0.3)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    viewModel.currentSearchTerm = searchBar.text
    dismissSelf(withCompletion: true)
  }
}

extension SearchViewController: KeyboardObserver {
  func keyboardWillShow(_ notification: Notification) {
    guard let rect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, !isKeyboardShowing else { return }
    originalInsets = tableView.contentInset
    var inset = tableView.contentInset
    inset.bottom += rect.height
    tableView.contentInset = inset
    tableView.scrollIndicatorInsets = inset
    isKeyboardShowing = true
  }
  
  func keyboardDidShow(_ notification: Notification) {
    
  }
  
  func keyboardWillHide(_ notification: Notification) {
    tableView.contentInset = originalInsets
    tableView.scrollIndicatorInsets = originalInsets
    isKeyboardShowing = false
  }
}
