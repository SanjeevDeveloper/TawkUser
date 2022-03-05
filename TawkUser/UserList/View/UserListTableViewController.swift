//
//  UserListTableViewController.swift
//  TawkUser
//
//  Created by Sanjeev on 02/03/22.
//

import UIKit
import Combine

class UserListTableViewController: UITableViewController {

    private var cancellables: Set<AnyCancellable> = []
    
    private let userListViewModel = UserListViewModel()
    lazy var searchBar:UISearchBar = UISearchBar()
    
    var retryButton: UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBarInNavigation()
        addTableViewProperties()
        getUserListFromServer()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userListViewModel.getTawkUsers()
    }
    // MARK: - Search Bar in Navigation Bar
    private func setupSearchBarInNavigation() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    // MARK: - Add Table View Feature
    private func addTableViewProperties() {
        tableView.registerReusableCell(NormalTableViewCell.self)
        tableView.registerReusableCell(NoteTableViewCell.self)
        tableView.registerReusableCell(InvertedTableViewCell.self)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
    }
    
    // MARK: - To get user list
    func getUserListFromServer() {
        userListViewModel.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.handlePopUps()
                self?.tableView.reloadData()
        }.store(in: &cancellables)
    }
    private func handlePopUps() {
        switch userListViewModel.state {
            case .isLoading:
                showSpinner()
            case .noInternet:
                showNetworkError(message: "No Internet Connection")
                setupRetryButton()
            case .failed:
                removeSpinner()
            case .loaded:
                removeSpinner()
                tableView.reloadData()
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userListViewModel.users?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (userListViewModel.users?.count ?? 0) - 1 {
            if !userListViewModel.isSearchActive {
                userListViewModel.loadMoreData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let user = userListViewModel.users?[indexPath.row], let cell = ListCellViewModel.userListTableViewCell(tableView: tableView, indexPath: indexPath, user: user) else {
            fatalError("cell not found")
        }
        cell.selectionStyle = .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileTableViewController") as? ProfileTableViewController {
            if let user = userListViewModel.users?[indexPath.row] {
                profileVC.userProfileDetailsVM = UserProfileDetailsViewModel(tawkUser: user)
                self.navigationController?.pushViewController(profileVC, animated: true)
            }
        }
    }
}

// MARK: UISearchBar Delegate
extension UserListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        if searchBar.text == "" {
            userListViewModel.isSearchActive = false
            getUserListFromServer()
        } else {
            userListViewModel.isSearchActive = true
            userListViewModel.getSearchResult(search: searchBar.text ?? "")
        }
    }
}

extension UserListTableViewController {
    func setupRetryButton() {
        retryButton?.removeFromSuperview()
        retryButton = nil
        retryButton = UIButton(type: .system)
        
        retryButton?.setTitle("Retry", for: .normal)
        
        retryButton?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(retryButton!)
        retryButton?.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5).isActive = true
        retryButton?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -5).isActive = true
        
        retryButton?.addTarget(self, action: #selector(retryToLoad), for: .touchUpInside)
    }
    @objc func retryToLoad() {
        getUserListFromServer()
        retryButton?.removeFromSuperview()
        retryButton = nil
    }
}
