//
//  NewsWidgetView.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 30.03.22.
//

import SwiftUI

struct NewsWidgetView: View {
    @ObservedObject var viewModel = NewsViewModel()
    
    var body: some View {
        NewsCard(news: self.viewModel.latestNews, latest: true)
            .scaleEffect(0.56)
    }
}

struct NewsWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        NewsWidgetView()
    }
}
