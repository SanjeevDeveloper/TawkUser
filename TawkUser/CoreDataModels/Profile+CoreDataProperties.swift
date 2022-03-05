//
//  Profile+CoreDataProperties.swift
//  TawkUser
//
//  Created by Sanjeev on 04/03/22.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var avatar: String?
    @NSManaged public var company: String?
    @NSManaged public var followers: Int32
    @NSManaged public var following: Int32
    @NSManaged public var name: String?
    @NSManaged public var note: String?
    @NSManaged public var blog: String?
    @NSManaged public var twitter: String?
    @NSManaged public var location: String?

}

extension Profile : Identifiable {

}
