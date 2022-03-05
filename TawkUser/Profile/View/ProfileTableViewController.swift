//
//  ProfileTableViewController.swift
//  TawkUser
//
//  Created by Sanjeev on 02/03/22.
//

import UIKit
import Combine

class ProfileTableViewController: UITableViewController {

    private var cancellables: Set<AnyCancellable> = []
    
    var userProfileDetailsVM: UserProfileDetailsViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewProperties()
        getTawkUserDetails()
    }
    
    // MARK: - Setup Table View
    private func setupTableViewProperties() {
        tableView.registerReusableCell(AvatarHederImageTableViewCell.self)
        tableView.registerReusableCell(UserDetailsTableViewCell.self)
        tableView.registerReusableCell(UserNotesTableViewCell.self)
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
    }
    
    // MARK: - Get Tawk User Details
    private func getTawkUserDetails() {
        userProfileDetailsVM.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.handlePopUps()
                self?.title = self?.userProfileDetailsVM.tawkUser?.profile?.name
                self?.tableView.reloadData()
        }.store(in: &cancellables)
        userProfileDetailsVM.getTwakUserDetails()
    }
    private func handlePopUps() {
        switch userProfileDetailsVM.state {
            case .isLoading:
                showSpinner()
            case .noInternet:
                showNetworkError(message: "No Internet Connection")
                self.navigationController?.popViewController(animated: true)
            case .failed(let message):
                showNetworkError(message: message)
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
        return userProfileDetailsVM.getNumberOfCells()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: AvatarHederImageTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            if let avatar = userProfileDetailsVM.tawkUser?.avatar {
                cell.setAvatarHeaderImage(avatarImageUrl: avatar)
            }
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 1 {
            let cell: UserDetailsTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            if let details = userProfileDetailsVM.tawkUser {
                cell.addUserDetailsInCell(details: details)
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell: UserNotesTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            if let details = userProfileDetailsVM.tawkUser {
                cell.setNotesToCell(taskUser: details)
            }
            
            cell.saveUserNotes = { [weak self] notes in
                // save notes in database
                self?.userProfileDetailsVM.saveUserNotes(notes: notes, completion: {
                    self?.navigationController?.popViewController(animated: true)
                })
            }
            cell.selectionStyle = .none
            return cell
        }
    }
}
