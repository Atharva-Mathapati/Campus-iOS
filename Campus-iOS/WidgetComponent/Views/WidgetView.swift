//
//  WidgetView.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 29.03.22.
//

import SwiftUI

struct WidgetView: View {
    @ObservedObject var viewModel = NewsViewModel()
    @StateObject var model: Model = Model()

    @State private var switch2Calendar = false
    @State private var switch2News = false
    @State private var switch2Map = false
    @State private var switch2Grades = false
    
    var body: some View {
        VStack {
            //Calendar Widget
            ZStack {
                Rectangle()
                    .cornerRadius(15)
                    .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.2), radius: 10.0)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 35, height: 200, alignment: .center)
                CalendarWidgetView()
                    .frame(width: UIScreen.main.bounds.width - 35, height: 200, alignment: .center)
                    .disabled(true)
                }
            .background(NavigationLink(destination: CalendarContentView(), isActive: $switch2Calendar) {
                            EmptyView()
                        })
            .onTapGesture { switch2Calendar.toggle() }
            
            HStack {
                //News Widget
                ZStack {
                    Rectangle()
                        .cornerRadius(10)
                        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.2), radius: 10.0)
                        .foregroundColor(Color(.systemGray6))
                        .frame(width: 175, height: 175, alignment: .leading)
                    NewsWidgetView()
                        .frame(width: 175, height: 175, alignment: .center)
                        .disabled(true)
                }
                .background(NavigationLink(destination: NewsView(), isActive: $switch2News) {
                                EmptyView()
                            })
                .onTapGesture { switch2News.toggle() }
                //Map Widget
                ZStack {
                    Rectangle()
                        .cornerRadius(10)
                        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.2), radius: 10.0)
                        .foregroundColor(Color(.systemGray6))
                        .frame(width: 175, height: 175, alignment: .trailing)
                    MapWidgetView(zoomOnUser: true,
                                  panelPosition: "down",
                                  canteens: [],
                                  selectedCanteenName: " ",
                                  selectedAnnotationIndex: 0)
                    .cornerRadius(10)
                    .frame(width: 175, height: 175, alignment: .center)
                    .disabled(true)
                }
                .background(NavigationLink(destination: MapView(zoomOnUser: true,
                                                                panelPosition: "down",
                                                                canteens: [],
                                                                selectedCanteenName: " ",
                                                                selectedAnnotationIndex: 0,
                                                                selectedCanteen: Cafeteria(location: Location(latitude: 0, longitude: 0, address: " "), name: " ", id: " ", queueStatusApi: nil))
                                           , isActive: $switch2Map) {
                                EmptyView()
                            })
                .onTapGesture { switch2Map.toggle() }
            }
            
            //News Widget
            ZStack {
                Rectangle()
                    .cornerRadius(15)
                    .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.2), radius: 10.0)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 35, height: 100, alignment: .center)
                GradeWidgetView()
                    .frame(width: UIScreen.main.bounds.width - 35, height: 100, alignment: .center)
                    .disabled(true)
            }
            .background(NavigationLink(destination: GradesScreen(model: model), isActive: $switch2Grades) {
                            EmptyView()
                        })
            .onTapGesture { switch2Grades.toggle() }
        }
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView()
    }
}
