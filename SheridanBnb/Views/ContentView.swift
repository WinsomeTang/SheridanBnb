import SwiftUI
import Firebase
import FirebaseFirestore

struct ContentView: View {
    @EnvironmentObject var displayViewModel: DisplayViewModel
    @State private var selectedWing: String?
    @State private var searchText: String = ""
    @State private var isFilterViewPresented = false
    @State private var selectedWingIndex: Int = 0
    @State private var activeClassroomId: String? = nil
    @State private var isFirstAppearance = true

    
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
        NavigationStack{
            VStack(spacing: 0) {
                ZStack {
                    VStack {
                        HStack{
                            Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                .frame(width:60, height:60)
                                .offset(x:60, y:1)
                            Text("Sheridan BNB")
                               
                                .font(.system(size: 33))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                
                                .padding(.top, 30)
                        }
                        
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
                .background(Color("BlueTheme"))
                    VStack(spacing: 0) {
                        List {
                            ForEach(filteredClassrooms.sorted { $0.classroomID.localizedStandardCompare($1.classroomID) == .orderedAscending }) { classroom in
                                ClassroomRowView(classroom: classroom)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 2)
                                    .listRowInsets(EdgeInsets())
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color("LightGreenTheme"))

                            }
                        }
                        .listStyle(PlainListStyle())
                        .padding(.horizontal, 0)
                        .background(Color("LightGreenTheme"))
                        .navigationDestination(for: IdentifiableClassroom.self) { classroom in
                            ClassroomDetailView(classroom: classroom)
                        }
                        .listStyle(PlainListStyle())
                        .padding(.horizontal, 15)
                        .background(Color("LightGreenTheme"))
                        .dismissKeyboardOnDrag()
                    }
                    .background(Color("LightGreenTheme"))
                }
                .edgesIgnoringSafeArea(.bottom)
                .onAppear {
                    if isFirstAppearance {
                        displayViewModel.fetchClassroomsFromFirestore()
                        isFirstAppearance = false
                    }
                }
                .onChange(of: displayViewModel.selectedWing) {
                    displayViewModel.fetchFilteredClassrooms(for: displayViewModel.selectedWing)
                    displayViewModel.updateAvailableTimes()
                }
                .onChange(of: searchText) {
                    displayViewModel.updateAvailableTimes()
                }
            }
        }
    }


struct ClassroomRowView: View {
    var classroom: IdentifiableClassroom

    var body: some View {
        NavigationLink(destination: ClassroomDetailView(classroom: classroom)) {
            HStack {
                VStack(alignment: .center) {
                    HStack{
                        Text("\(classroom.classroomID)")
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                            .foregroundColor(Color("BlueTheme"))
                        //switch statement
                        Image(systemName: "lock.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color.red)
//                            .offset(y:-3)
                        Image(systemName: "person.text.rectangle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color.orange)
                        Image(systemName: "lock.open.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color.blue)
                    }
                    .multilineTextAlignment(.center)
                    Text(classroom.availableTime)
                        .font(.system(size: 18))
                        .foregroundColor(Color.green)

                        .fontWeight(.bold)
                }
                .padding(13)
                .frame(maxWidth: .infinity, alignment: .center)

                Spacer()

            }
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("AquaTheme"), lineWidth: 2.5)
            )
            

        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(Color("BlueTheme"))
        .padding(.horizontal, 0)
        .listRowInsets(EdgeInsets())
    }
}




// Define a button style for wing buttons
struct WingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(20)
            .background(Color("AquaTheme"))
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
