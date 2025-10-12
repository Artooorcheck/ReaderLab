import SwiftUI

struct ColorItemView: View {
    @EnvironmentObject var appearanceVm: AppearanceViewModel
    
    let appearance: Appearance
    
    var body: some View {
        VStack(spacing: .maxEdge(1.1)){
            RoundedRectangle(cornerRadius: 10)
                .stroke(appearanceVm.textColor, lineWidth: 2)
                .frame(width: .maxEdge(10), height: .maxEdge(10))
                .overlay(
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(appearanceVm.backColor(appearance: appearance))
                        Text("Aa")
                            .font(.system(size: .maxEdge(3.3)))
                            .foregroundColor(appearanceVm.textColor(appearance: appearance))
                    }
                )
            Text(appearance.title)
                .foregroundColor(appearanceVm.textColor)
            
            Circle()
                .stroke(appearanceVm.textColor.opacity(0.5), lineWidth: 2)
                .frame(height: .maxEdge(2.2))
                .overlay(
                    ZStack{
                        if(appearance == appearanceVm.appearance) {
                            Circle()
                                .mask(
                                    ZStack{
                                        Circle()
                                        Image(uiImage: .completed)
                                            .resizable()
                                            .blendMode(.destinationOut)
                                            .padding(4)
                                    }
                                )
                                .foregroundColor(appearanceVm.textColor)
                        }
                    }
                )
        }
    }
}

#Preview {
    ColorItemView(appearance: .dark)
        .environmentObject(AppearanceViewModel())
}
