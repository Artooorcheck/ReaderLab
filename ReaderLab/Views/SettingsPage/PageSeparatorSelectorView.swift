import SwiftUI

struct PageSeparatorSelectorView: View {
    @EnvironmentObject var appearanceVm: AppearanceViewModel
    @EnvironmentObject var settings: SettingsViewModel
    
    var caseCount: Int {
        PageSeparator.allCases.count
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                Spacer(minLength: 0)
                ForEach(Array(PageSeparator.allCases.enumerated()), id: \.element) { index, mode in
                    Button {
                        withAnimation(.linear(duration: 0.1)) {
                            settings.setPageSeparator(mode)
                        }
                    } label : {
                        Text(mode.title)
                            .font(.system(size: .maxEdge(2.2)))
                            .foregroundColor(appearanceVm.textColor)
                    }
                    .frame(width: geometry.size.width / CGFloat(caseCount))
                    Spacer(minLength: 0)
                }
            }
            .frame(height: .maxEdge(5.5))
            .background(
                ZStack{
                    RoundedRectangle(cornerRadius: .maxEdge(1.6))
                        .foregroundColor(appearanceVm.background2Color)
                        .shadow(radius: 0.5)
                    RoundedRectangle(cornerRadius: .maxEdge(1.6))
                        .padding(2)
                        .foregroundColor(appearanceVm.backgroundColor)
                        .padding(.leading, CGFloat(settings.selectedIndex) * geometry.size.width / CGFloat(caseCount))
                        .padding(.trailing, CGFloat(1 - settings.selectedIndex) * geometry.size.width / CGFloat(caseCount))
                }
            )
        }
        .frame(height: .maxEdge(5.5))
    }
}

#Preview {
    PageSeparatorSelectorView()
        .environmentObject(AppearanceViewModel())
}
