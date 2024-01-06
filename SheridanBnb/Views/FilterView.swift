//
//  FilterView.swift
//  SheridanBnb
//
//  Created by Winsome Tang on 2024-01-05.
//

// FilterView.swift
import SwiftUI
struct FilterView: View {
    @EnvironmentObject var displayViewModel: DisplayViewModel
    @Binding var selectedWingIndex: Int // Use index instead of String?
    var wingIDs: [String]
    var onApply: () -> Void

    var body: some View {
        VStack {
            Text("Filter by Wing")
                .font(.headline)
                .padding()

            Picker("Select Wing", selection: $selectedWingIndex) {
                // Option for All Wings
                ForEach(0..<wingIDs.count, id: \.self) { index in
                    Text(wingIDs[index]).tag(index)
                }
            }
            .pickerStyle(MenuPickerStyle())

            Button("Apply") {
                onApply()
            }
            .buttonStyle(WingButtonStyle())
        }
        .padding()
    }
}

//
//#Preview {
//    FilterView()
//}
