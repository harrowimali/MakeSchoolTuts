//
//  NoteTableViewCell.swift
//  MakeSchoolNotes
//
//  Created by Martin Walsh on 29/05/2015.
//  Updated by Chris Orcutt on 09/07/2015.
//  Copyright © 2015 MakeSchool. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    //this init. the date formatter (once); using static computed property
    
    static var dateFormatter: NSDateFormatter = {
        var format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format
    }()
  
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    
    
    var note: Note?{
        didSet{
            if let note = note, title = title, date = date{
                title.text = note.title
                date.text = NoteTableViewCell.dateFormatter.stringFromDate(note.modificationDate)
            }
        }
    }
    
}