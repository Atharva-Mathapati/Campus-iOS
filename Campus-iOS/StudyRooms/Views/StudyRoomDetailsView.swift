//
//  StudyRoomDetailsView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 14.05.22.
//

import SwiftUI

struct StudyRoomDetailsView: View {
    
    @State var room: StudyRoom
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct StudyRoomDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        StudyRoomDetailsView(room: StudyRoom())
    }
}
