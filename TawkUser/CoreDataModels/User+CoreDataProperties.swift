//
//  User+CoreDataProperties.swift
//  TawkUser
//
//  Created by Sanjeev on 04/03/22.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var avatar: String?
    @NSManaged public var id: Int32
    @NSManaged public var isEdited: Bool
    @NSManaged public var login: String?
    @NSManaged public var note_id: String?
    @NSManaged public var site_admin: Bool
    @NSManaged public var profile: Profile?

}

extension User : Identifiable {

}
