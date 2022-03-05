//
//  UserNotesTableViewCell.swift
//  TawkUser
//
//  Created by Sanjeev on 02/03/22.
//

import UIKit

class UserNotesTableViewCell: UITableViewCell {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var noteTextView: UITextView!
    
    var saveUserNotes: ((String) -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setNotesToCell(taskUser: User) {
        if let notes = taskUser.profile?.note, notes.count>0 {
            noteTextView.text = notes
            noteTextView.textColor = .black
        } else {
            noteTextView.text = Constants.noteText
            noteTextView.textColor = .lightGray
        }
    }
    @IBAction func onClickedSaveNoteButton(_ sender: Any) {
        self.endEditing(true)
        saveUserNotes?(noteTextView.text)
    }
}

extension UserNotesTableViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Constants.noteText {
            textView.text = ""
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = Constants.noteText
            textView.textColor = .lightGray
        }
    }
}
extension UserNotesTableViewCell: Reusable {
    static var nib: UINib? {
        return UINib(nibName: String(describing: UserNotesTableViewCell.self), bundle: nil)
    }
}
