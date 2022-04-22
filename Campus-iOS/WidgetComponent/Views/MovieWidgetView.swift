//
//  MovieWidgetView.swift
//  Campus-iOS
//
//  Created by ghjtd hbmu on 15.04.22.
//

import SwiftUI

struct MovieWidgetView: View {
    @ObservedObject var viewModel = MoviesViewModel()
    
    func sortMovies() -> Movie {
        var movies: [Movie] = []
        for m in viewModel.movies {
            movies.append(m)
        }
        
        return movies[0]
    }
    
    var body: some View {
        MovieCard(movie: sortMovies())
    }
}

struct MovieWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        MovieWidgetView()
    }
}
