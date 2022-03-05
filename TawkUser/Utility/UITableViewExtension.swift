//
//  UITableViewExtension.swift
//  TawkUser
//
//  Created by Sanjeev on 05/03/22.
//

import Foundation
import UIKit

protocol Reusable {
  static var reuseIdentifier: String { get }
  static var nib: UINib? { get }
}

extension Reusable {
  static var reuseIdentifier: String { return String(describing: self) }
  static var nib: UINib? { return nil }
}

extension UITableView {
    // register cell on table view
    func registerReusableCell<T: UITableViewCell>(_: T.Type) where T: Reusable {
        if let nib = T.nib {
            self.register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }

    // dequeue cell
    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: Reusable  {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell: \(T.self) with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
