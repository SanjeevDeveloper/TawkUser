//
//  TawkUserServiceTests.swift
//  TawkUserTests
//
//  Created by Sanjeev on 05/03/22.
//
@testable import TawkUser
import XCTest

class TawkUserServiceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testUserListAPICall() {
        let mockAPISniper = MockAPISniper()
        mockAPISniper.getUserListFromServer(page: 0) { result in
            switch result {
            case .success(let user):
                XCTAssertTrue(user.count == 1)
                XCTAssertTrue(mockAPISniper.userListAPICalled)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
    func testUserProfileDetailsAPICall() {
        let mockAPISniper = MockAPISniper()
        mockAPISniper.getUserProfileDetails(path: "abc") { result in
            switch result {
            case .success(let userDetails):
                XCTAssertTrue(userDetails.login == "sanjeev")
                XCTAssertTrue(mockAPISniper.userDetailsAPICalled)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }

}

class MockAPISniper: APIProtocol {
    var userListAPICalled = false
    var userDetailsAPICalled = false
    func getUserListFromServer(page: Int, completion: @escaping ((Result<[UsersListModel], Error>) -> ())) {
        userListAPICalled = true
        completion(.success([UsersListModel(login: "Sanjeev", id: 34, node: "abas", avatar: "http://abc.com", siteAdmin: true)]))
    }
    
    func getUserProfileDetails(path: String, completion: @escaping ((Result<UserProfileDetailsModel, Error>) -> ())) {
        userDetailsAPICalled = true
        completion(.success(UserProfileDetailsModel(login: "sanjeev", id: 34, node: "absc", avatar: "http://abc.com", siteAdmin: true, location: "India", name: "Sanjeev Mishra", followers: 23, following: 43, twitter: "@sanjeev", blog: "http://abc.com", company: "Tawk")))
    }
}
