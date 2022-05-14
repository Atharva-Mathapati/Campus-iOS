//
//  StudyRoomsView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.05.22.
//

import SwiftUI

struct StudyRoomsView: View {
    
    @ObservedObject var viewModel = StudyRoomsViewModel()
    
    func getRoomsPerGroup(_ group: StudyRoomGroup) -> [StudyRoom]? {
        self.viewModel.response.rooms?.filter({ group.rooms?.contains($0.id) ?? false })
    }
    
    var body: some View {
        List {
            ForEach(self.viewModel.response.groups ?? [StudyRoomGroup](), id: \.id) { group in
                let groupRooms = self.getRoomsPerGroup(group)
                VStack {
                    NavigationLink(
                        destination:
                            StudyRoomGroupView(selectedGroup: group, rooms: groupRooms)
                                .navigationTitle(group.name ?? "")
                                .navigationBarTitleDisplayMode(.inline)
                    ) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(group.name ?? "")
                                .fontWeight(.bold)
                            HStack(alignment: .top) {
                                Image(systemName: "number.circle.fill")
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(Color("tumBlue"))
                                Text("\(groupRooms?.count ?? 0)")
                                    .font(.system(size: 12))
                                Spacer()
                                if let details = group.detail, !details.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    
                                    Image(systemName: "info.circle.fill")
                                        .frame(width: 12, height: 12)
                                        .foregroundColor(Color("tumBlue"))
                                    Text(details)
                                        .font(.system(size: 12))
                                }
                            }
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .foregroundColor(.init(.darkGray))
                            .padding()
                                
                            Spacer()
                                .frame(height: 1)
                        }
                        .padding(.leading, 4)
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

struct StudyRoomsView_Previews: PreviewProvider {
    static var previews: some View {
        StudyRoomsView()
    }
}
