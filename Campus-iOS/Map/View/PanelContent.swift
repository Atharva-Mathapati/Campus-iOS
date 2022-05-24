//
//  PanelContent.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 16.12.21.
//

import SwiftUI
import CoreLocation

struct PanelContent: View {
    @Binding var zoomOnUser: Bool
    @Binding var panelPosition: String
    @Binding var lockPanel: Bool
    @Binding var canteens: [Cafeteria]
    @Binding var selectedCanteen: Cafeteria?
    @Binding var studyRoomsResponse: StudyRoomApiRespose
    @Binding var selectedRoomGroup: StudyRoomGroup?
    @Binding var mode: MapMode
    @Binding var setAnnotations: Bool
    
    @State private var searchString = ""
    @State private var mealPlanViewModel: MealPlanViewModel?
    @State private var sortedCanteens: [Cafeteria] = []
    @State private var sortedGroups: [StudyRoomGroup] = []
        
    var locationManager = CLLocationManager()
    
    private let handleThickness = CGFloat(0)
    
    var body: some View {
        VStack{
            
            Spacer().frame(height: 10)
            
            RoundedRectangle(cornerRadius: CGFloat(5.0) / 2.0)
                        .frame(width: 40, height: CGFloat(5.0))
                        .foregroundColor(Color.black.opacity(0.2))
            
            if selectedCanteen != nil {
                
                CanteenView(selectedCanteen: $selectedCanteen)
                if let viewModel = mealPlanViewModel{
                    MealPlanView(viewModel: viewModel)
                }
                
                Spacer()
            } else if selectedRoomGroup != nil {
                StudyRoomGroupView(
                    selectedGroup: $selectedRoomGroup,
                    rooms: selectedRoomGroup?.getRooms(allRooms: studyRoomsResponse.rooms ?? [StudyRoom]())
                )
                
                Spacer()
            } else {
                HStack {
                    Spacer()
                    
                    Menu(content: {
                        Button(action: {
                            self.mode = .cafeterias
                            self.setAnnotations = true
                        }, label: {
                            Label("Cafeterias", systemImage: "fork.knife")
                        })
                        Button(action: {
                            self.mode = .studyRooms
                            self.setAnnotations = true
                        }, label: {
                            Label("Study Rooms", systemImage: "book.fill")
                        })
                    }) {
                        if mode == .cafeterias {
                            Image(systemName: "fork.knife")
                        } else {
                            Image(systemName: "book.fill")
                        }
                    }
                    
                    Spacer()
                    
                    Button (action: {
                        zoomOnUser = true
                        if panelPosition == "up" {
                            panelPosition = "pushMid"
                        }
                    }) {
                        Image(systemName: "location")
                            .font(.title2)
                    }
                    
                    Spacer()
                    
                    PanelSearchBar(panelPosition: $panelPosition,
                              lockPanel: $lockPanel,
                              searchString: $searchString)
                    
                    Spacer().frame(width: 0.25 * UIScreen.main.bounds.width/10,
                                   height: 1.5 * UIScreen.main.bounds.width/10)
                }
                switch mode {
                case .cafeterias:
                    List {
                        ForEach (sortedCanteens.indices.filter({ searchString.isEmpty ? true : sortedCanteens[$0].name.localizedCaseInsensitiveContains(searchString) }), id: \.self) { id in
                            Button(action: {
                                selectedCanteen = sortedCanteens[id]
                                panelPosition = "pushMid"
                                lockPanel = false
                            }, label: {
                                PanelRow(cafeteria: self.$sortedCanteens[id])
                            })
                        }
                    }
                    .searchable(text: $searchString, prompt: "Look for something")
                    .listStyle(PlainListStyle())
                case .studyRooms:
                    List {
                        ForEach (sortedGroups.indices.filter({ searchString.isEmpty ? true : sortedGroups[$0].name?.localizedCaseInsensitiveContains(searchString) ?? false }) , id: \.self) { id in
                            Button(action: {
                                selectedRoomGroup = sortedGroups[id]
                                panelPosition = "pushMid"
                                lockPanel = false
                            }, label: {
                                StudyGroupRow(
                                    studyGroup: sortedGroups[id],
                                    allRooms: self.studyRoomsResponse.rooms ?? [StudyRoom]()
                                )
                            })
                        }
                    }
                    .searchable(text: $searchString, prompt: "Look for something")
                    .listStyle(PlainListStyle())
                }
                
            }
        }
        .onChange(of: selectedCanteen) { optionalCafeteria in
            if let cafeteria = optionalCafeteria {
                mealPlanViewModel = MealPlanViewModel(cafeteria: cafeteria)
            }
        }
        .onChange(of: canteens) { unsortedCanteens in
            if let location = self.locationManager.location {
                sortedCanteens = unsortedCanteens.sorted {
                    $0.coordinate.location.distance(from: location) < $1.coordinate.location.distance(from: location)
                }
            }
            else {
                sortedCanteens = unsortedCanteens
            }
        }
        .onChange(of: self.studyRoomsResponse) { unsortedgroups in
            if let location = self.locationManager.location, let groups = unsortedgroups.groups {
                sortedGroups = groups.sorted {
                    if let lhs = $0.coordinate, let rhs = $1.coordinate {
                        return lhs.location.distance(from: location) < rhs.location.distance(from: location)
                    } else {
                        return false
                    }
                }
            }
            else {
                sortedGroups = unsortedgroups.groups ?? [StudyRoomGroup]()
            }
        }
    }
}

struct PanelContent_Previews: PreviewProvider {
    
    @State static var mode: MapMode = .cafeterias
    
    static var previews: some View {
        PanelContent(zoomOnUser: .constant(true),
                     panelPosition: .constant(""),
                     lockPanel: .constant(false),
                     canteens: .constant([]),
                     selectedCanteen: .constant(Cafeteria(location: Location(latitude: 0.0,
                                                                             longitude: 0.0,
                                                                             address: ""),
                                                          name: "",
                                                          id: "",
                                                          queueStatusApi: "")),
                     studyRoomsResponse: .constant(StudyRoomApiRespose()),
                     selectedRoomGroup: .constant(nil),
                     mode: $mode,
                     setAnnotations: .constant(true))
            .previewInterfaceOrientation(.portrait)
    }
}
