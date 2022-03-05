//
//  AvatarHederImageTableViewCell.swift
//  TawkUser
//
//  Created by Sanjeev on 02/03/22.
//

import UIKit

class AvatarHederImageTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setAvatarHeaderImage(avatarImageUrl: String) {
        avatarImage.showImageFromUrl(urlString: avatarImageUrl, imageMode: .scaleAspectFit)
    }
}
extension AvatarHederImageTableViewCell: Reusable {
    static var nib: UINib? {
        return UINib(nibName: String(describing: AvatarHederImageTableViewCell.self), bundle: nil)
    }
}
