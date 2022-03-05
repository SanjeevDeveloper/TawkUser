//
//  InvertedTableViewCell.swift
//  TawkUser
//
//  Created by Sanjeev on 02/03/22.
//

import UIKit

class InvertedTableViewCell: NormalTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    func updateInvertedCellWithData(user: User) {
        userImageView.showImageFromUrl(urlString: user.avatar ?? "", inverted: true, imageMode: .scaleAspectFill)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension InvertedTableViewCell: InvertedCellProtocol {
    func setupInvertedCell(user: User) {
        if user.isEdited {
            contentView.backgroundColor = .lightGray
        }
        userImageView.showImageFromUrl(urlString: user.avatar ?? "", inverted: true, imageMode: .scaleAspectFill)
        usernameLabel.text = user.login
        detailLabel.text = user.note_id
        if user.site_admin {
            setupSiteAdminUser()
        }
    }
}
