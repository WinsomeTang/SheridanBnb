import SwiftUI

struct FilterView: View {
    @EnvironmentObject var displayViewModel: DisplayViewModel
    @Binding var isPresented: Bool
    
    //    //State variables for new filtering options
    //    @State private var excludeLocked = false
    //    @State private var excludeKeycardRequired = false
    //    @State private var showOccupiedRooms = false
    //    @State private var showEverything = false
    
    var wingIDs: [String] = ["A", "B", "C", "E", "G", "J", "S", "ALL"]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Select Filters")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(Color.white)
                
                // Toggle filters
                Toggle("Exclude Locked", isOn: $displayViewModel.excludeLocked)
                Toggle("Exclude Keycard Required", isOn: $displayViewModel.excludeKeycardRequired)
                Toggle("Show Occupied Rooms", isOn: $displayViewModel.showOccupiedRooms)
                Toggle("Show EVERYTHING", isOn: $displayViewModel.showEverything)
                    .onChange(of: displayViewModel.showEverything) { newValue in
                        if newValue {
                            // Automatically turn off other toggles when "Show EVERYTHING" is turned on.
                            displayViewModel.excludeLocked = false
                            displayViewModel.excludeKeycardRequired = false
                            displayViewModel.showOccupiedRooms = true
                        }
                    }
                
                Divider()
                
                Text("Select a wing")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(Color.white)
                
                // Grid of buttons for wing selection
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(wingIDs, id: \.self) { wingID in
                            Button(action: {
                                buttonTapped(with: wingID)
                            }) {
                                Text(wingID)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    // Change the background color based on the selected state
                                    .background(displayViewModel.selectedWings.contains(wingID) ? Color.blue : Color.white)
                                    .foregroundColor(displayViewModel.selectedWings.contains(wingID) ? Color.white : Color("BlueTheme"))
                                    .cornerRadius(40)
                            }
                        }
                        .padding(5)
                    }
                    .padding()
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("BlueTheme"))
            .ignoresSafeArea()
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            }, trailing: Button("Apply") {
                applyFilters()
            })
        }
    }
    
    
    func buttonTapped(with wing: String) {
        if wing == "ALL" {
            displayViewModel.selectedWings = (displayViewModel.selectedWings.contains("ALL") ? [] : ["ALL"])
        } else {
            if let index = displayViewModel.selectedWings.firstIndex(of: wing) {
                displayViewModel.selectedWings.remove(at: index)
            } else {
                displayViewModel.selectedWings.append(wing)
                // If "ALL" was selected and now a specific wing is selected, remove "ALL" from the selection.
                displayViewModel.selectedWings.removeAll { $0 == "ALL" }
            }
        }
    }
    
    func applyFilters() {
        // Apply the filters based on the state variables
        displayViewModel.applyFilters()
        isPresented = false
    }
    
    struct FilterView_Previews: PreviewProvider {
        static var previews: some View {
            FilterView(isPresented: .constant(true))
                .environmentObject(DisplayViewModel())
        }
    }
}
