//
//  SheridanBnbApp.swift
//  SheridanBnb
//
//  Created by Winsome Tang on 2024-01-04.
//

import SwiftUI
import Firebase

@main
struct SheridanBnbApp: App {
    let displayViewModel = DisplayViewModel()
    init(){
        FirebaseApp.configure()
        print("firebase configuration complete!")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(displayViewModel)
        }
    }
}
