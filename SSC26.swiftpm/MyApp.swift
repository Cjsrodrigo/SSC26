import SwiftUI

@main
struct MyApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            
            AppRootView()
                .task { @MainActor in
                                AudioSystem.shared.warmUp()
                            }
        }
    }
}
