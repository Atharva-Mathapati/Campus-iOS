//
//  CalendarManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Alamofire
import XMLParser
import SwiftyJSON

class CalendarManager: Manager {
    
    static var calendarItems = [CalendarRow]()
    
    let main: TumDataManager?
    var single = false
    required init(mainManager: TumDataManager) {
        main = mainManager
    }
    
    init(mainManager: TumDataManager, single: Bool) {
        main = mainManager
        self.single = single
    }
    
    func fetchData(handler: ([DataElement]) -> ()) {
        if CalendarManager.calendarItems.isEmpty {
            let url = getURL()
            Alamofire.request(.GET, url).responseString() { (response) in
                if let data = response.result.value {
                    let dataAsDictionary = XMLParser.sharedParser.decode(data)
                    let json = JSON(dataAsDictionary)
                    if let titleArray = json["title"].array, startArray = json["dtstart"].array, end = json["dtend"].array, descriptionArray = json["description"].array, statusArray = json["status"].array, linkArray = json["url"].array {
                        for i in 0...(titleArray.count - 1) {
                            let item = CalendarRow()
                            item.title = titleArray[i].string
                            let startString = startArray[i].string
                            let endString = end[i].string
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            if let s = startString, e = endString {
                                item.dtstart = dateFormatter.dateFromString(s)
                                item.dtend = dateFormatter.dateFromString(e)
                            }
                            item.description = descriptionArray[i].string
                            item.status = statusArray[i].string
                            if let link = linkArray[i].string {
                                item.url = NSURL(string: link)
                            }
                            CalendarManager.calendarItems.append(item)
                        }
                        self.handle(handler)
                    }
                }
            }
        } else {
            handle(handler)
        }
    }
    
    func handle(handler: ([DataElement]) -> ()) {
        let onlyNew = CalendarManager.calendarItems.filter() { (item) in
            return item.dtstart?.compare(NSDate()) == NSComparisonResult.OrderedDescending
        }
        if single {
            if !onlyNew.isEmpty {
                handler([onlyNew[0]])
            }
        } else {
            handler(onlyNew as [DataElement])
        }
    }
    
    func getURL() -> String {
        let base = TUMOnlineWebServices.BaseUrl.rawValue + TUMOnlineWebServices.Calendar.rawValue
        if let token = main?.getToken() {
            return base + "?" + TUMOnlineWebServices.TokenParameter.rawValue + "=" + token
        }
        return ""
    }
}