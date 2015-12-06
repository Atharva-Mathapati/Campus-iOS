//
//  NextLectureCardCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit
import MCSwipeTableViewCell

class NextLectureCardCell: CardTableViewCell {

    @IBOutlet weak var lectureTitelLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func setElement(element: DataElement) {
        if let calendarItem = element as? CalendarRow {
            lectureTitelLabel.text = calendarItem.title
            let dateformatter = NSDateFormatter()
            dateformatter.dateFormat = "hh:mm"
            if let s = calendarItem.dtstart, e = calendarItem.dtend {
                let start = dateformatter.stringFromDate(s)
                let end = dateformatter.stringFromDate(e)
                timeLabel.text = start + " - " + end
            }
        }
    }
   
    @IBOutlet weak var cardView: UIView! {
        didSet {
            backgroundColor = UIColor.clearColor()
            cardView.layer.shadowOpacity = 0.4
            cardView.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        }
    }

}
