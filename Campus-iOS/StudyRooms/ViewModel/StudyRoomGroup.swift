//
//  StudyRoomGroup.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.05.22.
//

import Foundation

struct StudyRoomGroup: Entity {
    var detail: String?
    var id: Int64
    var name: String?
    var sorting: Int64
    var rooms: [Int64]?
    
    enum CodingKeys: String, CodingKey {
        case detail = "detail"
        case name = "name"
        case id = "nr"
        case sorting = "sortierung"
        case rooms = "raeume"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let detail = try container.decode(String.self, forKey: .detail)
        let name = try container.decode(String.self, forKey: .name)
        let id = try container.decode(Int64.self, forKey: .id)
        let sorting = try container.decode(Int64.self, forKey: .sorting)
        let room_nrs = try container.decode([Int64].self, forKey: .rooms)
        
        self.detail = detail
        self.name = name
        self.id = id
        self.sorting = sorting
        self.rooms = room_nrs
    }
}
