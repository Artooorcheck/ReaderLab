import SwiftUI

@main
struct ReaderLabApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(MainViewModel())
                .environmentObject(AppearanceViewModel())
                .environmentObject(SettingsViewModel())
        }
    }
}
