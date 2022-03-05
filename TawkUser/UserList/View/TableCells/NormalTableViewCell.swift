//
//  NormalTableViewCell.swift
//  TawkUser
//
//  Created by Sanjeev on 02/03/22.
//

import UIKit

class NormalTableViewCell: UITableViewCell {
    let userImageView: UIImageView = UIImageView()
    let usernameLabel: UILabel = UILabel()
    let detailLabel: UILabel = UILabel()
    var adminLabel: UILabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(userImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(detailLabel)
        
        userImageView.layer.cornerRadius = 30
        userImageView.clipsToBounds = true
        userImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        
        usernameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 8).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        detailLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 8).isActive = true
        detailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 0).isActive = true
        detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSiteAdminUser() {
        adminLabel = UILabel()
        adminLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(adminLabel)
        
        adminLabel.text = "admin"
        
        adminLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        adminLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
    }
}
extension NormalTableViewCell: Reusable {
}
extension NormalTableViewCell: NormalCellProtocol {
    func setupNormalCellForUser(user: User) {
        if user.isEdited {
            contentView.backgroundColor = .lightGray
        } else {
            contentView.backgroundColor = .white
        }
        userImageView.showImageFromUrl(urlString: user.avatar ?? "", imageMode: .scaleAspectFill)
        usernameLabel.text = user.login
        detailLabel.text = user.note_id
        if user.site_admin {
            setupSiteAdminUser()
        } else {
            adminLabel.removeFromSuperview()
        }
    }
}
