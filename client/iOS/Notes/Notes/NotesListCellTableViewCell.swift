//
//  NotesListCellTableViewCell.swift
//  Notes
//
//  Created by Mahbub Morshed on 1/7/16.
//  Copyright © 2016 Mahbub Morshed. All rights reserved.
//

import UIKit

class NotesListCellTableViewCell: UITableViewCell {
    @IBOutlet weak var NoteDetails: UILabel!
    @IBOutlet weak var NoteTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}