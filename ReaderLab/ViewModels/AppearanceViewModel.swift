import Foundation
import SwiftUI


enum Appearance: String, CaseIterable, Identifiable {
    case light
    case dark
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

class AppearanceViewModel: ObservableObject {
    @Published private(set) var appearance: Appearance
    
    init() {
        appearance = .light
    }
    
    init(_ appearance: ColorScheme) {
        self.appearance = .light
        setAppearance(appearance)
    }
    
    var textColor: Color {
        textColor(appearance: appearance)
    }
    
    var backgroundColor: Color {
        backColor(appearance: appearance)
    }
    
    var cardColor: Color {
        switch appearance {
        case .dark:
            return Color(red: 0.3, green: 0.3, blue: 0.3)
        case .light:
            return .white
        }
    }
    
    var background2Color: Color {
        switch appearance {
        case .dark:
            return Color(red: 0.5, green: 0.5, blue: 0.5)
        case .light:
            return Color(red: 0.8, green: 0.8, blue: 0.8)
        }
    }
    
    var sliderColor: Color {
        switch appearance {
        case .dark:
            return .white
        case .light:
            return .blue
        }
    }
    
    var completeColor: Color {
        switch appearance {
        case .dark:
            return Color(red: 0, green: 0.4, blue: 0)
        case .light:
            return .green
        }
    }
    
    func backColor(appearance: Appearance) -> Color {
        switch appearance {
        case .dark:
            return .black
        case .light:
            return .white
        }
    }
    
    func textColor(appearance: Appearance) -> Color {
        switch appearance {
        case .dark:
            return .white
        case .light:
            return .black
        }
    }
    
    func setAppearance(_ appearance: Appearance) {
        self.appearance = appearance
        UserDefaults.standard.set(appearance.rawValue, forKey: "appearance")
    }
    
    func setAppearance(_ appearance: ColorScheme) {
        if let val = Appearance(rawValue: UserDefaults.standard.string(forKey: "appearance") ?? "") {
            self.appearance = val
            return
        }
        switch appearance {
        case .dark:
            self.appearance = .dark
        case .light:
            self.appearance = .light
        @unknown default:
            self.appearance = .light
        }
    }
}
