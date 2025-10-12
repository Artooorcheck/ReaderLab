import Foundation
import SwiftUI
import PDFKit


enum PageSeparator: String, CaseIterable, Identifiable {
    case vertical
    case horizontal
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .vertical: return "Vertical"
        case .horizontal: return "Horizontal"
        }
    }
}

class SettingsViewModel: ObservableObject {
    @Published private(set) var pageSeparator: PageSeparator
    @Published private(set) var selectedIndex: Int = 0
    
    var displayMode: PDFDisplayMode {
        return .singlePageContinuous
    }
    
    var displayDirection: PDFDisplayDirection {
        if(pageSeparator == .horizontal) {
            return .horizontal
        }
        return .vertical
    }
    
    init() {
        if let val = PageSeparator(rawValue: UserDefaults.standard.string(forKey: "pageSeparator") ?? "") {
            self.pageSeparator = val
            self.selectedIndex = PageSeparator.allCases.firstIndex(of: pageSeparator) ?? 0
            return
        }
        self.pageSeparator = .vertical
    }
    
    func setPageSeparator(_ separator: PageSeparator) {
        self.pageSeparator = separator
        UserDefaults.standard.set(separator.rawValue, forKey: "pageSeparator")
        self.selectedIndex = PageSeparator.allCases.firstIndex(of: pageSeparator) ?? 0
    }
}
