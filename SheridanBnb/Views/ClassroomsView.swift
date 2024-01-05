//
//  ClassroomsView.swift
//  SheridanBnb
//
//  Created by Michael Werbowy on 2024-01-05.
//

import SwiftUI

struct ClassroomsView: View {
    @EnvironmentObject var displayViewModel: DisplayViewModel
    var wingID: String
    
    var body: some View {
        List {
            ForEach(displayViewModel.classrooms(in: wingID)) { classroom in
                Text("\(classroom.classroomID)")
            }
        }
        .navigationTitle("Classrooms in Wing \(wingID)")
        .onAppear {
            displayViewModel.fetchClassroomsFromFirestore(for: wingID)
        }
    }
}


#Preview {
    ClassroomsView()
}
