//
//  UsersListModel.swift
//  TawkUser
//
//  Created by Sanjeev on 04/03/22.
//

import Foundation

struct UsersListModel: Codable {
    var login: String
    var id: Int
    var node: String
    var avatar: String
    var siteAdmin: Bool
    
    enum CodingKeys: String, CodingKey {
            case node = "node_id", login, id
            case avatar = "avatar_url"
            case siteAdmin = "site_admin"
        }
}
