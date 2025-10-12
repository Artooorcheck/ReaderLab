import SwiftUI

struct ColorSchemeSelectorView: View {
    @EnvironmentObject var appearanceVm: AppearanceViewModel
    
    var body: some View {
        HStack {
            Spacer(minLength: 0)
            
            ForEach(Appearance.allCases) { mode in
                Button{
                    withAnimation(.linear(duration: 0.5)){
                        appearanceVm.setAppearance(mode)
                    }
                } label: {
                    ColorItemView(appearance: mode)
                }
                Spacer(minLength: 0)
            }
        }
    }
}

#Preview {
    ColorSchemeSelectorView()
        .environmentObject(AppearanceViewModel())
}
