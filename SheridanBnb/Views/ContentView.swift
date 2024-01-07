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
        // The main stack for the entire screen
        VStack(spacing: 0) {
            // The blue section at the top including the "Sheridan BNB" title and the search bar
            ZStack {
//                Color("Blue")
//                    .edgesIgnoringSafeArea(.all)

                VStack {
                   
                    Text("Sheridan BNB")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        
                        .padding(.top, 30)

                    HStack {
                        SearchBar(text: $searchText)
                            .padding()
                        Button {
                            isFilterViewPresented.toggle()
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                        }
                        .offset(x: -20)
                        .buttonStyle(WingButtonStyle())
                        .sheet(isPresented: $isFilterViewPresented) {
                            FilterView(selectedWingIndex: $selectedWingIndex, wingIDs: displayViewModel.wingIDs, onApply: {
                                if selectedWingIndex == 0 {
                                    selectedWing = "All"
                                } else {
                                    selectedWing = displayViewModel.wingIDs[selectedWingIndex]
                                }
                                displayViewModel.fetchClassroomsFromFirestore()
                                isFilterViewPresented.toggle()
                            })
                            .environmentObject(displayViewModel)
                        }
                    }
                }
                .padding(.bottom)
            }
            .background(Color("Blue"))

            // This VStack will contain the list and will have the light green background
            VStack(spacing: 0) { // No spacing between elements inside this VStack
                List {
                    ForEach(filteredClassrooms.sorted { $0.classroomID.localizedStandardCompare($1.classroomID) == .orderedAscending }) { classroom in
                        VStack(alignment: .leading) {
                            Text("\(classroom.classroomID) in Wing \(classroom.wingID)")
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .font(.system(size: 22))
                                .fontWeight(.bold)
                                .foregroundColor(Color("Blue"))
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding(.vertical, 30)
                        .background(Color("White"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color("Light Green"), lineWidth: 45)
                        )
                        // Remove default padding
                        .listRowInsets(EdgeInsets())
                    }
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal, 15)
                .background(Color("Light Green"))
            }
            .padding(.top, 15)
            .background(Color("Light Green"))
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            displayViewModel.fetchClassroomsFromFirestore()
        }
    }
}

// Define a button style for wing buttons
struct WingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(20)
            .background(Color("Aqua"))
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

