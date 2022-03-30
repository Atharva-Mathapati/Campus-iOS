//
//  CalendarWidgetView.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 29.03.22.
//

import SwiftUI
import KVKCalendar

struct CalendarWidgetView: View {
    
    @EnvironmentObject private var model: Model
    @ObservedObject var viewModel: CalendarViewModel
    
    @State var selectedType: CalendarType = .day
    @State var selectedEventID: String?
    @State var isTodayPressed: Bool = true
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE \nMMMM \nd"
        return formatter
    }()
     
    init() {
        self.viewModel = CalendarViewModel()
    }
    
    var body: some View {
        HStack {
            Spacer().frame(width: 20)
            VStack {
                Spacer().frame(height: 20)
                Text(Date.now, formatter: CalendarWidgetView.dateFormatter)
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
            }
            GeometryReader { geo in
                CalendarDisplayView(
                    events: self.viewModel.events.map({ $0.kvkEvent }),
                    type: .day,
                    selectedEventID: self.$selectedEventID,
                    frame: Self.getSafeAreaFrame(geometry: geo),
                    todayPressed: self.$isTodayPressed,
                    isWidget: true)
                .accessibilityRespondsToUserInteraction(true)
                .cornerRadius(15)
            }
        }
    }
    
    static func getSafeAreaFrame(geometry: GeometryProxy) -> CGRect {
        let origin = UIScreen.main.bounds.origin
        
        return CGRect(x: origin.x, y: origin.y, width: geometry.size.width, height: geometry.size.height)
    }
}

struct CalendarWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarWidgetView()
            .previewInterfaceOrientation(.portrait)
    }
}

