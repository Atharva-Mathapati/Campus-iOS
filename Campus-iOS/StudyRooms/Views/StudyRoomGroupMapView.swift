//
//  StudyRoomGroupMapView.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 14.05.22.
//

import SwiftUI
import MapKit

struct StudyRoomGroupMapView: View {
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    var body: some View {
        Map(coordinateRegion: $region)
            .frame(width: 400, height: 300)
    }
}

struct StudyRoomGroupMapView_Previews: PreviewProvider {
    static var previews: some View {
        StudyRoomGroupMapView()
    }
}
