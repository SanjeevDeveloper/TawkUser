//
//  UserListTests.swift
//  TawkUserTests
//
//  Created by Sanjeev on 05/03/22.
//

import XCTest
@testable import TawkUser
class UserListTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUserListInsertion() {
        let listViewModel = MockUserList()
        listViewModel.insertTawkUserRecords(records: [UsersListModel(login: "Sanjeev", id: 34, node: "abas", avatar: "http://abc.com", siteAdmin: true)])
        XCTAssertTrue(listViewModel.pageSize == 0)
        XCTAssertTrue(listViewModel.insertTawkUser)
    }
    func testGetUserList() {
        let listViewModel = MockUserList()
        listViewModel.getTawkUsers()
        XCTAssertTrue(listViewModel.getTawkUser)
    }
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}

class MockUserList: UserListProtocol {
    var insertTawkUser = false
    var getTawkUser = false
    var pageSize: Int = 0
    
    var users: [User]?
    
    func insertTawkUserRecords(records: [UsersListModel]) {
        insertTawkUser = true
    }
    
    func getTawkUsers() {
        getTawkUser = true
    }
}
