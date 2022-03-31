//
//  GradeWidgetView.swift
//  Campus-iOS
//
//  Created by August Wittgenstein on 31.03.22.
//

import SwiftUI

struct GradeWidgetView: View {
    @StateObject private var vm = GradesViewModel(
        serivce: GradesService()
    )
    
    var body: some View {
        Text("abc")
    }
        
    func getLatestGrade() -> [(String, [Grade])] {
        let grades = vm.sortedGradesBySemester
        print(grades)
        return grades
    }
}

struct GradeWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        GradeWidgetView()
    }
}
