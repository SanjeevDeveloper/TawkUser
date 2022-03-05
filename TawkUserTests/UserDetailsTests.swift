//
//  UserDetailsTests.swift
//  TawkUserTests
//
//  Created by Sanjeev on 05/03/22.
//

import XCTest
@testable import TawkUser

class UserDetailsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDetailsFetch() {
        let profileDetails = MockUserDetails()
        profileDetails.fetchUserProfile(username: "sanjeev")
        XCTAssertTrue(profileDetails.fetchedUserProfile)
    }
    func testNumberCells() {
        let profileDetails = MockUserDetails()
        let cell = profileDetails.getNumberOfCells()
        XCTAssertTrue(profileDetails.numberOfCellsCalled)
        XCTAssertTrue(cell == 10)
    }
    func testSaveUserNotes() {
        let profileDetails = MockUserDetails()
        profileDetails.saveUserNotes(notes: "test") {
            XCTAssertTrue(true)
            XCTAssertTrue(profileDetails.saveUserNotes)
        }
    }
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}

class MockUserDetails: UserDetailsProtocol {
    var fetchedUserProfile = false
    var numberOfCellsCalled = false
    var saveUserNotes = false
    
    var tawkUser: User?
    
    func fetchUserProfile(username: String) {
        fetchedUserProfile = true
    }
    
    func getNumberOfCells() -> Int {
        numberOfCellsCalled = true
        return 10
    }
    
    func saveUserNotes(notes: String, completion: (() -> ())) {
        saveUserNotes = true
        completion()
    }
    
    
}
