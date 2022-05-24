//
//  StudyRoomGroupView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.05.22.
//

import SwiftUI

struct StudyRoomGroupView: View {
    @Binding var selectedGroup: StudyRoomGroup?
    @State var rooms: [StudyRoom]?
    
    var body: some View {
        if let group = selectedGroup {
            VStack {
                HStack{
                    VStack(alignment: .leading){
                        Text(group.name ?? "")
                            .bold()
                            .font(.title3)
                        Text(group.detail ?? "")
                            .font(.subheadline)
                            .foregroundColor(Color.gray)
                    }
                    
                    Spacer()

                    Button(action: {
                        selectedGroup = nil
                    }, label: {
                        Text("Done")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.blue)
                                .padding(.all, 5)
                                .background(Color.clear)
                                .accessibility(label:Text("Close"))
                                .accessibility(hint:Text("Tap to close the screen"))
                                .accessibility(addTraits: .isButton)
                                .accessibility(removeTraits: .isImage)
                        })
                }
                .padding(.all, 10)
                
                List {
                    ForEach(self.rooms ?? [StudyRoom](), id: \.id) { room in
                        Collapsible(title: {
                            AnyView(
                                HStack {
                                    VStack(alignment: .leading) {
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
                                        .padding(.leading)
                                        .padding(.trailing)
                                    }
                                    
                                    Spacer()
                                    
                                    room.localizedStatus
                                }
                            )
                        }) {
                            StudyRoomDetailsView(room: room)
                        }
                    }
                }
            }
        }
    }
}

struct StudyRoomGroupView_Previews: PreviewProvider {
    static var previews: some View {
        StudyRoomGroupView(selectedGroup: .constant(StudyRoomGroup()))
    }
}
