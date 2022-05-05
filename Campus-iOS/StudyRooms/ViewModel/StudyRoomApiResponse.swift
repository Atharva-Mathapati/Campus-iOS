//
//  StudyRoomApiResponse.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.05.22.
//

import Foundation

struct StudyRoomApiRespose: Entity {
    var rooms: [StudyRoom]?
    var groups: [StudyRoomGroup]?
    
    enum CodingKeys: String, CodingKey {
        case rooms = "raeume"
        case groups = "gruppen"
    }
    
    init() {
        self.rooms = nil
        self.groups = nil
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let rooms = try container.decode([StudyRoom].self, forKey: .rooms)
        let groups = try container.decode([StudyRoomGroup].self, forKey: .groups)
        
        self.rooms = rooms
        self.groups = groups
    }
}
