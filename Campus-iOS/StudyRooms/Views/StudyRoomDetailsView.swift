//
//  StudyRoomDetailsView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 14.05.22.
//

import SwiftUI

struct StudyRoomDetailsView: View {
    
    @State var room: StudyRoom
    
    func printCell(key: String, value: String?) -> some View {
        if let val = value {
            return AnyView(HStack {
                Text(key)
                Spacer()
                Text(val).foregroundColor(.gray)
            })
        }
        
        return AnyView(EmptyView())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            printCell(key: "Building", value: room.buildingName)
            printCell(key: "Building Number", value: String(room.buildingNumber))
            printCell(key: "Building Code", value: room.buildingCode)
            // Text("\(room.raum_nr_architekt ?? "")")
            if let attributes = room.attributes, attributes.count > 0 {
                Text("Attributes:")
                ForEach(attributes, id: \.name) { attribute in
                    HStack {
                        Spacer()
                        Text("\(attribute.name ?? "") \(attribute.detail ?? "")")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

struct StudyRoomDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        StudyRoomDetailsView(room: StudyRoom())
    }
}
