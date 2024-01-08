import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      print("firebase configuration complete!")
    return true
  }
}

@main
struct SheridanBnbApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let displayViewModel = DisplayViewModel()
    
    var body: some Scene {
        WindowGroup {
                MainEntryView()
                    .environmentObject(displayViewModel)
        }
    }
}
