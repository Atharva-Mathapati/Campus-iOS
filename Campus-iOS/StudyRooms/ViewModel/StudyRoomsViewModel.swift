//
//  StudyRoomsViewModel.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.05.22.
//

import Foundation
import Alamofire

class StudyRoomsViewModel: ObservableObject {
    @Published var response = StudyRoomApiRespose()
    
    typealias ImporterType = Importer<StudyRoomGroup, StudyRoomApiRespose, JSONDecoder>
    private let sessionManager: Session = Session.defaultSession
    
    init() {
        // TODO: Get from cache, if not found, then fetch
        fetch()
    }
    
    func fetch() {
        let endpoint: URLRequestConvertible = TUMDevAppAPI.rooms
        let importer = ImporterType(endpoint: endpoint)
        
        importer.performFetch(handler: { result in
            switch result {
            case .success(let incoming):
                self.response = incoming
            case .failure(let error):
                print(error)
            }
        })
    }
}
