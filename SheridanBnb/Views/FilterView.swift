//
//  FilterView.swift
//  SheridanBnb
//
//  Created by Winsome Tang on 2024-01-05.
//

import SwiftUI

struct FilterView: View {
    @EnvironmentObject var displayViewModel: DisplayViewModel
    @Binding var isPresented: Bool

    var wingIDs: [String] = ["A", "B", "C", "E", "G", "J", "S", "ALL"]
    
    

    var body: some View {
        VStack {
            Text("Select a wing")
                .font(.headline)
                .padding()

            // Grid of buttons
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(wingIDs, id: \.self) { wingID in
                    Button(action: {
//                        self.buttonTapped(with: wingID)
                        buttonTapped(with: wingID)
                    }) {
                        Text(wingID)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding()
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
