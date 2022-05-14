//
//  StudyRoomGroupView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.05.22.
//

import SwiftUI

struct StudyRoomGroupView: View {
    @State var selectedGroup: StudyRoomGroup
    @State var rooms: [StudyRoom]?
    
    var body: some View {
        List {
            ForEach(self.rooms ?? [StudyRoom](), id: \.id) { room in
                VStack {
                    NavigationLink(
                        destination:
                            StudyRoomDetailsView(room: room)
                                .navigationBarTitleDisplayMode(.inline)
                    ) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(room.name ?? "")
                                    .fontWeight(.bold)
                                HStack {
                                    Image(systemName: "barcode.viewfinder")
                                        .frame(width: 12, height: 12)
                                        .foregroundColor(Color("tumBlue"))
                                    Text(room.code ?? "")
                                        .font(.system(size: 12))
                                    Spacer()
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .foregroundColor(.init(.darkGray))
                                .padding()
                            }
                            .padding(.leading, 4)
                            
                            Spacer()
                            
                            room.localizedStatus
                        }
                    }
                }
                .listRowInsets(
                    EdgeInsets(
                        top: 4,
                        leading: 18,
                        bottom: 2,
                        trailing: 18
                    )
                )
            }
        }
    }
}

struct StudyRoomGroupView_Previews: PreviewProvider {
    static var previews: some View {
        StudyRoomGroupView(selectedGroup: StudyRoomGroup())
    }
}
