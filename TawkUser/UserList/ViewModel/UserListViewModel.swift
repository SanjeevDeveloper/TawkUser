//
//  UserListViewModel.swift
//  TawkUser
//
//  Created by Sanjeev on 02/03/22.
//

import Foundation
import Combine
import CoreData

protocol UserListProtocol: ObservableObject {
    var pageSize: Int {get set}
    var users: [User]? {get set}
    func insertTawkUserRecords(records: [UsersListModel])
    func getTawkUsers()
}
class UserListViewModel: UserListProtocol {
    
    var isSearchActive: Bool = false
    var pageSize: Int = 0
    @Published var users: [User]? = []
    
    enum State {
        case isLoading
        case failed(String)
        case loaded
        case noInternet
    }
    @Published private(set) var state = State.isLoading
    
    private let service: APIProtocol
    init(service: APIProtocol = APISniper()) {
        self.service = service
    }
    
    // MARK: - Get Tawk User
    /// this method first try to get data from local database. If it will not get data from there then it call the API to for user listing
    func getTawkUsers() {
        CoreDataStorage.shared.printDocumentDirectoryPath()
        let result = CoreDataStorage.shared.fetchManagedObject(managedObject: User.self)
        if let tawkUsers = result, tawkUsers.count>0 {
            users?.append(contentsOf: tawkUsers)
            state = .loaded
        } else {
            fetchTawkUsersFromAPI(page: 0)
        }
    }
    
    // MARK: - Get Tawk User From API
    /// this method get the users from the server and it store to local database
    private func fetchTawkUsersFromAPI(page: Int) {
        if NetworkReachable.isConnectedToNetwork() {
            state = .loaded
            service.getUserListFromServer(page: page) { [weak self] result in
                switch result {
                case .success(let users):
                    if self?.pageSize == 0 {
                        self?.pageSize = users.count
                    }
                    self?.insertTawkUserRecords(records: users)
                case .failure(let error):
                    print("Error retrieving users: \(error.localizedDescription)")
                    self?.state = .failed(error.localizedDescription)
                }
            }
        } else {
            state = .noInternet
        }
    }
    
    // MARK: - Load More Operation
    /// this method responsible for load more data, when user will be reach on last showing cell then this method will be called.
    /// First time page size will be zero, when we will get first page data, will assign data count to page size.
    func loadMoreData() {
        if pageSize>0 && (users?.count ?? 0)%pageSize == 0 {
            fetchTawkUsersFromAPI(page: (users?.count ?? 0)/pageSize)
        }
    }
    // MARK: - Insert in local database
    /// Method will to store user list what we have got from server, it will store.
    func insertTawkUserRecords(records: [UsersListModel]) {
        CoreDataStorage.shared.persistentContainer.performBackgroundTask { privateManagedContext in
            //insert code
            records.forEach { userList in
                let user = User(context: privateManagedContext)
                user.login = userList.login
                user.id = Int32(userList.id)
                user.note_id = userList.node
                user.avatar = userList.avatar
                user.site_admin = userList.siteAdmin
                user.isEdited = false
            }

            if(privateManagedContext.hasChanges){
                try? privateManagedContext.save()
            }
        }
        getTawkUsers()
    }
    
    // MARK: - Get Search Result
    /// Method responsible to get search result on the basis of user input. Whaever user input in UISearch Bar
    /// Logic is here, search text contains in login(username) or note(in detail screen user input locally).
    func getSearchResult(search: String) {
        if search == "" {
            self.isSearchActive = false
        } else {
            self.isSearchActive = true
        }
        let request: NSFetchRequest<User> = User.fetchRequest()
                
        let predicate = NSPredicate(format: "login CONTAINS[c] %@ OR profile.note CONTAINS[c] %@", search, search)
        request.predicate = predicate
                
        do {
            let result = try CoreDataStorage.shared.persistentContainer.viewContext.fetch(request)
            if result.count>0 {
                users = result
            } else {
                users = []
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}
