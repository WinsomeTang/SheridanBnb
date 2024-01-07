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
    
//    var filteredClassrooms: [IdentifiableClassroom] {
//        let filteredBySearch = searchText.isEmpty ? displayViewModel.availableClassrooms : displayViewModel.availableClassrooms.filter { $0.classroomID.lowercased().contains(searchText.lowercased()) }
//        return displayViewModel.selectedWing == nil ? filteredBySearch : filteredBySearch.filter { $0.wingID == displayViewModel.selectedWing }
//    }
    
    var filteredClassrooms: [IdentifiableClassroom] {
        if searchText.isEmpty {
            // If there's no search text, use the classrooms based on the selected wing
            return displayViewModel.availableClassrooms
        } else {
            // If there is search text, perform search regardless of the selected wing
            return displayViewModel.availableClassrooms.filter {
                $0.classroomID.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                VStack {
                   
                    Text("Sheridan BNB")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        
                        .padding(.top, 30)

                    HStack {
                        SearchBar(text: $searchText, onEditingChanged: { isEditing in
                            if isEditing {
                                displayViewModel.selectedWing = nil
                            }
                        })

                        Button {
                            isFilterViewPresented.toggle()
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                        }
                        .offset(x: -20)
                        .buttonStyle(WingButtonStyle())
                        .sheet(isPresented: $isFilterViewPresented) {
                            FilterView(isPresented: $isFilterViewPresented)
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
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color("Light Green"), lineWidth: 45)
                        )
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal, 15)
                .background(Color("Light Green"))
                .dismissKeyboardOnDrag()
                .simultaneousGesture(DragGesture().onChanged { _ in
                    UIApplication.shared.dismissKeyboard()
                })
//                .onTapGesture {
//                    UIApplication.shared.dismissKeyboard()
//                }
            }
            .padding(.top, 15)
            .background(Color("Light Green"))
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            displayViewModel.fetchClassroomsFromFirestore()
        }
        .onChange(of: displayViewModel.selectedWing) { newWing in
            displayViewModel.fetchFilteredClassrooms(for: newWing)
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

struct DismissKeyboardOnDrag: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                UIApplication.shared.dismissKeyboard()
            }
            .gesture(DragGesture().onChanged { _ in
                UIApplication.shared.dismissKeyboard()
            })
    }
}

#if canImport(UIKit)
extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
#endif

extension View {
    func dismissKeyboardOnDrag() -> some View {
        self.modifier(DismissKeyboardOnDrag())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(DisplayViewModel())
    }
}
