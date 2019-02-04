//
//  NoteTableViewCell.swift
//  Landmark Remark
//
//  Created by Jay Salvador on 4/2/19.
//  Copyright © 2019 Jay Salvador. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    weak var note: Note? {
        didSet {
            if let note = note {
                self.setNoteView(note: note)
            }
        }
    }
    
    private func setNoteView(note: Note){
        if let icon = note.user.icon {
            self.imgIcon.image = UIImage.init(named: icon)
        }
        
        var time = ""
        if let date = Note.stringToDate(dateString: note.date){
            time = " • \(Date.init().offset(from: date))"
        }
        
        self.lblUser.text = "@\(note.user.username)\(time)"
        self.lblMessage.text = note.notes
    }
    
    static func cellIdentifier() -> String {
        return "NoteTableViewCell"
    }
}
