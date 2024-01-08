import SwiftUI

struct FilterView: View {
    @EnvironmentObject var displayViewModel: DisplayViewModel
    @Binding var isPresented: Bool

    var wingIDs: [String] = ["A", "B", "C", "E", "G", "J", "S", "ALL"]
    
    var body: some View {
        VStack {
            Text("Select a wing")
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(Color.white)
            // Grid of buttons
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(wingIDs, id: \.self) { wingID in
                    Button(action: {
                        buttonTapped(with: wingID)
                    }) {
                        Text(wingID)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(Color("BlueTheme"))
                            .cornerRadius(40)
                    }
                }
                .padding(5)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BlueTheme"))
        .ignoresSafeArea()
    }
        
        
    func buttonTapped(with wing: String) {
        displayViewModel.selectedWing = wing == "ALL" ? nil : wing
        isPresented = false
    }
}


struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(isPresented: .constant(true))
            .environmentObject(DisplayViewModel())
    }
}
