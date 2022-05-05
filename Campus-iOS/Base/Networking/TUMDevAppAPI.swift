//
//  TUMDevAppAPI.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.05.22.
//

import Foundation
import Alamofire

enum TUMDevAppAPI: URLRequestConvertible {
    case room(roomNr: Int)
    case rooms
    
    static let baseURL = "https://www.devapp.it.tum.de"
    
    var path: String {
        switch self {
        case .room, .rooms:             return "iris/ris_api.php"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: return .get
        }
    }
    
    static var requiresAuth: [String] = []
    
    func asURLRequest() throws -> URLRequest {
        let url = try TUMDevAppAPI.baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        
        switch self {
        case .room(let roomNr):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["format": "json", "raum": roomNr])
        case .rooms:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["format": "json"])
        }
        
        return urlRequest
    }
}
