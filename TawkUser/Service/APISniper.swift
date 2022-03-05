//
//  APISniper.swift
//  TawkUser
//
//  Created by Sanjeev on 02/03/22.
//

import Foundation
import Network

protocol APIProtocol {
    func getUserListFromServer(page: Int, completion: @escaping ((Result<[UsersListModel], Error>) -> ()))
    func getUserProfileDetails(path: String, completion: @escaping ((Result<UserProfileDetailsModel, Error>) -> ()))
}

final class APISniper {
    fileprivate let userList = "https://api.github.com/users?since="
    fileprivate let profile = "https://api.github.com/users/"
    let monitor = NWPathMonitor()
    
    let network = NetworkStatus.shared
    var saveRequests: [DispatchWorkItem] = []
    init() {
        network.start()
    }
    
    /// center method to call APIs
    func getDataFromAPI(path: String, completion: @escaping ((Data?, Error?) -> ())) {
        guard let url = URL(string: path) else {
            return
        }
        let blockOperation = BlockOperation()
        blockOperation.addExecutionBlock {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                completion(data, error)
            }.resume()
        }
        
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        
        operationQueue.addOperation(blockOperation)
        
        /// listener will listen connection is available or not and act accordingly
        /// if connection will not be availble, it will store in a array and execute that later on, on connection availability
        network.listener = { isConnected in
            if isConnected, self.saveRequests.count>0 {
                self.processAllAPIs()
            } else {
                self.saveRequest {
                    self.getDataFromAPI(path: path, completion: completion)
                }
            }
        }
        
    }
    
    /// method to store block of request when connection will not be available
    private func saveRequest(block: @escaping (() -> ())) {
        saveRequests.append(DispatchWorkItem {
            block()
        })
    }
    /// Method to process all apis what we have available in our saveRequests array
    private func processAllAPIs() {
        saveRequests.forEach({DispatchQueue.global().async(execute: $0)})
        saveRequests.removeAll()
    }
}

extension APISniper: APIProtocol {
    
    // MARK: - Get User Profile
    func getUserProfileDetails(path: String, completion: @escaping ((Result<UserProfileDetailsModel, Error>) -> ())) {
        let profilePath = profile + path
        getDataFromAPI(path: profilePath) { (data, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let users = try decoder.decode(UserProfileDetailsModel.self, from: data)
                    completion(.success(users))
                } catch let err {
                    completion(.failure(err))
                }
            }
       }
    }
    
    // MARK: - Get User List
    func getUserListFromServer(page: Int, completion: @escaping ((Result<[UsersListModel], Error>) -> ())) {
        let userListPath = userList + "\(page)"
        getDataFromAPI(path: userListPath) { (data, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let users = try decoder.decode([UsersListModel].self, from: data)
                    completion(.success(users))
                } catch let err {
                    completion(.failure(err))
                }
            }
       }
    }
}
