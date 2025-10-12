import Foundation
import SwiftUI

extension View {
    func frame(rWidth: CGFloat = .infinity, rHeight: CGFloat = .infinity, alignment: Alignment = .center) -> some View {
        GeometryReader { geometry in
            self
                .frame(width: geometry.size.width * rWidth, height: geometry.size.height * rHeight)
                .frame(maxWidth: .infinity, alignment: alignment)
                .frame(maxHeight: .infinity, alignment: alignment)
        }
    }
}
