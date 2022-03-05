//
//  UserDetailsTableViewCell.swift
//  TawkUser
//
//  Created by Sanjeev on 02/03/22.
//

import UIKit

class UserDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var blogLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func addUserDetailsInCell(details: User) {
        followerLabel.text = "followers: \(String(describing: details.profile?.followers ?? 0))"
        followingLabel.text = "following: \(String(describing: details.profile?.followers ?? 0))"
        usernameLabel.text = details.profile?.name ?? Constants.notAvailable
        companyLabel.text = details.profile?.company ?? Constants.notAvailable
        blogLabel.text = details.profile?.blog ?? Constants.notAvailable
    }
}
extension UserDetailsTableViewCell: Reusable {
    static var nib: UINib? {
        return UINib(nibName: String(describing: UserDetailsTableViewCell.self), bundle: nil)
    }
}
