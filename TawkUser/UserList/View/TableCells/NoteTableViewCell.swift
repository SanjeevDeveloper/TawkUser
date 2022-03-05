//
//  NoteTableViewCell.swift
//  TawkUser
//
//  Created by Sanjeev on 02/03/22.
//

import UIKit

class NoteTableViewCell: NormalTableViewCell {

    let noteImageView: UIImageView = UIImageView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension NoteTableViewCell: NoteCellProtocol {
    func addNoteContainingCell(user: User) {
        if user.isEdited {
            contentView.backgroundColor = .lightGray
        }
        userImageView.showImageFromUrl(urlString: user.avatar ?? "", imageMode: .scaleAspectFill)
        usernameLabel.text = user.login
        detailLabel.text = user.note_id
        if user.site_admin {
            setupSiteAdminUser()
        }
        noteImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(noteImageView)
        noteImageView.image = UIImage(named: "note")
        noteImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        noteImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        noteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        noteImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
