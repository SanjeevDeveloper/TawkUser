//
//  UserProfileViewModel.swift
//  TawkUser
//
//  Created by Sanjeev on 04/03/22.
//

import Foundation
import Combine

protocol UserDetailsProtocol: ObservableObject {
    var tawkUser: User? {get set}
    func fetchUserProfile(username: String)
    func getNumberOfCells() -> Int
    func saveUserNotes(notes: String, completion: (() -> ()))
}

class UserProfileDetailsViewModel: UserDetailsProtocol {
    
    @Published var tawkUser: User?
    private let service: APIProtocol
    enum State {
        case isLoading
        case failed(String)
        case loaded
        case noInternet
    }
    @Published private(set) var state = State.isLoading
    init(tawkUser: User, service: APIProtocol = APISniper()) {
        self.tawkUser = tawkUser
        self.service = service
    }
    
    // MARK: - Get Tawk User Details
    /// Method will get details about user, if user's details not in local database, it request to server for the same record.
    func getTwakUserDetails() {
        if tawkUser?.profile == nil, let username = tawkUser?.login {
            fetchUserProfile(username: username)
        } else {
            state = .loaded
        }
    }
    
    // MARK: - Get user details from API
    /// it will request to server for user details
    func fetchUserProfile(username: String) {
        if NetworkReachable.isConnectedToNetwork() {
            state = .isLoading
            service.getUserProfileDetails(path: username) { [weak self] result in
                switch result {
                case .success(let userDetails):
                    self?.insertTawkUserDetailsRecords(details: userDetails)
                case .failure(let error):
                    print("Error retrieving users: \(error.localizedDescription)")
                    self?.state = .failed(error.localizedDescription)
                }
            }
        } else {
            state = .noInternet
        }
    }
    
    // MARK: - Insert In database
    /// method to store details what we have got from server in local database
    func insertTawkUserDetailsRecords(details: UserProfileDetailsModel) {
        let profile = Profile(context: CoreDataStorage.shared.context)
        profile.name = details.name ?? ""
        profile.company = details.company ?? ""
        profile.avatar = details.avatar
        profile.followers = Int32(details.followers)
        profile.following = Int32(details.following)
        profile.note = ""
        profile.blog = details.blog
        profile.location = details.location
        profile.twitter = details.twitter
        tawkUser?.profile = profile
        tawkUser?.isEdited = true
        if(CoreDataStorage.shared.context.hasChanges){
            try? CoreDataStorage.shared.context.save()
        }
        state = .loaded
    }
    
    // MARK: - Get number of cells required for Controller
    /// if we have details about user then cells are visible otherwise 0 cell will be visible
    func getNumberOfCells() -> Int {
        tawkUser?.profile == nil ? 0 : 3
    }
    // MARK: - Save Note
    /// When user will save note in details, it will store in local database
    func saveUserNotes(notes: String, completion: (() -> ())) {
        tawkUser?.profile?.note = notes
        if(CoreDataStorage.shared.context.hasChanges){
            try? CoreDataStorage.shared.context.save()
        }
        completion()
    }
}
