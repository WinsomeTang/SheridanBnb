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
    @State private var selectedWing: String?
    
    var filteredClassrooms: [IdentifiableClassroom] {
        if let selectedWing = selectedWing, selectedWing != "All" {
            return displayViewModel.availableClassrooms.filter { $0.wingID == selectedWing }
        } else {
            return displayViewModel.availableClassrooms
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Available Classrooms")
                    .font(.headline)
                    .padding()

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(displayViewModel.wingIDs, id: \.self) { wingID in
                            Button(wingID) {
                                self.selectedWing = wingID
                                if wingID == "All" {
                                    // Call fetchClassroomsFromFirestore without arguments
                                    displayViewModel.fetchClassroomsFromFirestore()
                                } else {
                                    // Fetch filtered classrooms for the selected wing
                                    displayViewModel.fetchFilteredClassrooms(for: wingID)
                                }
                            }
                            .buttonStyle(WingButtonStyle())
                        }
                    }
                }
                
                List(filteredClassrooms.sorted {
                    $0.classroomID.localizedStandardCompare($1.classroomID) == .orderedAscending
                }) { classroom in
                    Text("\(classroom.classroomID) in Wing \(classroom.wingID)")
                }
            }
            .navigationBarTitle("Sheridan Bnb", displayMode: .large)
            .onAppear {
                displayViewModel.fetchClassroomsFromFirestore()
            }
        }
    }
}

// Define a button style for wing buttons
struct WingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct ClassroomsView: View {
    @EnvironmentObject var displayViewModel: DisplayViewModel
    var wingID: String
    
    var body: some View {
        List(displayViewModel.availableClassrooms) { classroom in
            Text("\(classroom.classroomID) in Wing \(classroom.wingID)")
        }
        .navigationTitle("Classrooms in Wing \(wingID)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(DisplayViewModel())
    }
}

