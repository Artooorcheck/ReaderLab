import SwiftUI

struct SliderView: View {
    @State var value: CGFloat = 0.9
    @EnvironmentObject var appearance: AppearanceViewModel
    
    var body: some View {
        HStack{
            GeometryReader{ geometry in
                ZStack{
                    RoundedRectangle(cornerRadius: .maxEdge(1))
                        .foregroundColor(.gray.opacity(0.5))
                    RoundedRectangle(cornerRadius: .maxEdge(1))
                        .padding(.trailing, (1 - value) * geometry.size.width)
                        .mask {
                            RoundedRectangle(cornerRadius: .maxEdge(1))
                        }
                }
            }
            .frame(height: .maxEdge(1))
            Text("\(Int(value * 100))%")
                .font(.system(size: .maxEdge(2)))
                .bold()
                .frame(width: value >= 1 ? 0 : 50)
            Circle()
                .foregroundColor(.green)
                .mask {
                    ZStack{
                        Circle()
                        Image(uiImage: UIImage.completed)
                            .resizable()
                            .blendMode(.destinationOut)
                            .padding(5)
                    }
                }
                .frame(width: value >= 1 ? 30 : 0)
                
        }
        .foregroundColor(value >= 1 ? .green : appearance.sliderColor)
    }
}

#Preview {
    SliderView()
        .environmentObject(AppearanceViewModel(.dark))
}
