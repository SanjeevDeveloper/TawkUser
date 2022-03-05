//
//  UserProfileDetailsModel.swift
//  TawkUser
//
//  Created by Sanjeev on 04/03/22.
//

import Foundation

struct UserProfileDetailsModel: Codable {
    var login: String
    var id: Int
    var node: String
    var avatar: String
    var siteAdmin: Bool
    var location: String?
    var name: String?
    var followers: Int
    var following: Int
    var twitter: String?
    var blog: String
    var company: String?
    
    enum CodingKeys: String, CodingKey {
            case node = "node_id", login, id, location, name, followers, following, blog, company
            case avatar = "avatar_url"
            case siteAdmin = "site_admin"
            case twitter = "twitter_username"
        }
}
