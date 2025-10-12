import SwiftUI

struct SearchFieldView: View {
    @EnvironmentObject var appearanceVm: AppearanceViewModel
    @Binding var text: String
    
    var body: some View {
        TextField("", text: $text)
            .foregroundColor(appearanceVm.textColor)
            .overlay(
                HStack{
                    Text(text.isEmpty ? "Search" : "")
                        .foregroundColor(appearanceVm.textColor.opacity(0.5))
                    Spacer(minLength: 0)
                }
            )
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(appearanceVm.cardColor)
                    .shadow(radius: 2)
            )
    }
}

#Preview {
    ContentView()
        .environmentObject(MainViewModel())
        .environmentObject(AppearanceViewModel())
}
