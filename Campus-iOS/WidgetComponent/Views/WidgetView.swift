//
//  WidgetView.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 29.03.22.
//

import SwiftUI

struct WidgetView: View {
    @State private var isActive = false
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .cornerRadius(20)
                    .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.2), radius: 10.0)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 40, height: 200, alignment: .center)
                CalendarWidgetView()
                    .frame(width: UIScreen.main.bounds.width - 40, height: 200, alignment: .center)
                    .disabled(true)
                }
            .background(NavigationLink(destination: CalendarContentView(), isActive: $isActive) {
                            EmptyView()
                        })
            .onTapGesture { isActive.toggle() }
        }
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView()
    }
}
