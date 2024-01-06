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
    @State private var searchText: String = ""
    @State private var isFilterViewPresented = false
    @State private var selectedWingIndex: Int = 0

    var filteredClassrooms: [IdentifiableClassroom] {
        let filteredBySearch = searchText.isEmpty ? displayViewModel.availableClassrooms : displayViewModel.availableClassrooms.filter { $0.classroomID.lowercased().contains(searchText.lowercased()) }

        if let selectedWing = selectedWing, selectedWing != "All" {
            return filteredBySearch.filter { $0.wingID == selectedWing }
        } else {
            return filteredBySearch
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding()

                Text("Available Classrooms")
                    .font(.headline)
                    .padding()

                Button("Filter") {
                    isFilterViewPresented.toggle()
                }
                .buttonStyle(WingButtonStyle())
                .sheet(isPresented: $isFilterViewPresented) {
                    FilterView(selectedWingIndex: $selectedWingIndex, wingIDs: displayViewModel.wingIDs, onApply: {
                        if selectedWingIndex == 0 {
                            selectedWing = "All"
                            displayViewModel.fetchClassroomsFromFirestore()
                        } else {
                            selectedWing = displayViewModel.wingIDs[selectedWingIndex]
                            displayViewModel.fetchFilteredClassrooms(for: selectedWing ?? "")
                        }
                        isFilterViewPresented.toggle()
                    })
                    .environmentObject(displayViewModel)
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

