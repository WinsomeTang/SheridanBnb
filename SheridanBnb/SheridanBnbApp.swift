//
//  SheridanBnbApp.swift
//  SheridanBnb
//
//  Created by Winsome Tang on 2024-01-04.
//

import SwiftUI
import FirebaseCore


@main
struct SheridanBnbApp: App {
    init(){
        FirebaseApp.configure()
        print("firebase configuration complete!")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
