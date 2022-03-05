//
//  ListCellViewModel.swift
//  TawkUser
//
//  Created by Sanjeev on 05/03/22.
//

import Foundation
import UIKit

protocol NormalCellProtocol {
    func setupNormalCellForUser(user: User)
}
protocol NoteCellProtocol {
    func addNoteContainingCell(user: User)
}
protocol InvertedCellProtocol {
    func setupInvertedCell(user: User)
}
struct ListCellViewModel {
    
    static func userListTableViewCell(tableView: UITableView, indexPath: IndexPath, user: User) -> UITableViewCell? {
        if (indexPath.row+1)%4 == 0 {
            // inverted cell
            let cell: InvertedTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.setupInvertedCell(user: user)
            return cell
        } else if let notes = user.profile?.note, notes.count>0 {
            let cell: NoteTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.addNoteContainingCell(user: user)
            return cell
        } else {
            let cell: NormalTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.setupNormalCellForUser(user: user)
            return cell
        }
    }
}
