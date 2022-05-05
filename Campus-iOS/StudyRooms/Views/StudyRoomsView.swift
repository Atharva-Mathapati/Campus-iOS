//
//  StudyRoomsView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.05.22.
//

import SwiftUI

struct StudyRoomsView: View {
    
    @ObservedObject var viewModel = StudyRoomsViewModel()
    
    var body: some View {
        List {
            ForEach(self.viewModel.response.groups ?? [StudyRoomGroup](), id: \.id) { group in
                Text(group.name ?? "")
            }
        }
    }
}

struct StudyRoomsView_Previews: PreviewProvider {
    static var previews: some View {
        StudyRoomsView()
    }
}
