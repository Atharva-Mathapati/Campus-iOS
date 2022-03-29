//
//  TumCalendarStyle.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 12.02.22.
//

import Foundation
import SwiftUI
import KVKCalendar

struct TumCalendarWidgetStyle {
    @available(*, unavailable) private init() {}
    
    static func getStyle(type: CalendarType) -> Style {
        var style = Style()
        if UIDevice.current.userInterfaceIdiom == .phone {
            style.timeline.widthTime = 40
            style.timeline.currentLineHourWidth = 45
            style.timeline.offsetTimeX = 2
            style.timeline.offsetLineLeft = 2
            style.headerScroll.titleDateAlignment = .center
            style.headerScroll.titleDateFont = .boldSystemFont(ofSize: 0)
            style.headerScroll.heightSubviewHeader = 0
            style.headerScroll.heightHeaderWeek = 0
            style.allDay.height = 0
        } else {
            style.timeline.widthEventViewer = 350
        }
        
        // Event
        style.event.showRecurringEventInPast = true
        style.event.states = [.none]
        if #available(iOS 13.0, *) {
            style.event.iconFile = UIImage(systemName: "paperclip")
        }
        
        // Timeline
        style.timeline.offsetTimeY = 25
        // cuts out the hours before the first event if true
        style.timeline.startFromFirstEvent = false
                
        // Day
        style.allDay.backgroundColor = .systemBackground
        
        return addDarkMode(style: style)
    }
    
    static func addDarkMode(style: Style) -> Style {
        
        var newStyle = style
        
        // Event
        newStyle.event.colorIconFile = UIColor.useForStyle(dark: .systemGray, white: newStyle.event.colorIconFile)
        
        // Timeline
        newStyle.timeline.backgroundColor = UIColor.useForStyle(dark: .black, white: newStyle.timeline.backgroundColor)
        newStyle.timeline.timeColor = UIColor.useForStyle(dark: .systemGray, white: newStyle.timeline.timeColor)
        newStyle.timeline.currentLineHourColor = UIColor.useForStyle(dark: .systemRed,
                                                                     white: newStyle.timeline.currentLineHourColor)

        // all day
        newStyle.allDay.backgroundColor = UIColor.useForStyle(dark: .systemGray6, white: newStyle.allDay.backgroundColor)
        newStyle.allDay.titleColor = UIColor.useForStyle(dark: .white, white: newStyle.allDay.titleColor)
        newStyle.allDay.textColor = UIColor.useForStyle(dark: .white, white: newStyle.allDay.textColor)
                
        return newStyle
    }
}

