//
//  ContentView.swift
//  SheridanBnb
//
//  Created by Winsome Tang on 2024-01-04.
//
import SwiftUI
import Firebase
import FirebaseFirestore


struct ContentView: View {
    @EnvironmentObject var displayViewModel: DisplayViewModel
    var body: some View {
          VStack {
              Text("Available Classrooms:")
                  .font(.headline)

              List(displayViewModel.availableClassrooms) { classroom in
                  Text("\(classroom.classroomID) in Wing \(classroom.wingID)")
              }
          }
          .onAppear {
              displayViewModel.fetchClassroomsFromFirestore()
          }
      }
  }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(DisplayViewModel())
    }
}
