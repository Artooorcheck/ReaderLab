import SwiftUI

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct AddFieldView: View {
    @Binding var active: Bool
    @Binding var scrollY: CGFloat
    
    var body: some View {
        GeometryReader{ geometry in
            Color.clear
                .preference(
                    key: ScrollOffsetKey.self,
                    value: geometry.frame(in: .global).minY
                )
                .frame(width: 0)
                .onPreferenceChange(ScrollOffsetKey.self) { value in
                    scrollY = -value
                    if(scrollY < 50){
                        active = true
                    }
                }
            Rectangle()
                .fill(RadialGradient(colors: [.blue.opacity(Double(150 - scrollY) / 150), .blue.opacity(0.0)], center: UnitPoint(x: UnitPoint.center.x, y: 0.625), startRadius: 25, endRadius: 300))
                .cornerRadius(50)
                .overlay(
                    ZStack{
                        Circle()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.blue)
                            .overlay {
                                ZStack{
                                    Text("+")
                                        .font(.system(size: 50))
                                        .bold()
                                        .padding(10)
                                        .padding(.bottom, 10)
                                        .foregroundColor(.white)
                                        .background(
                                            Circle()
                                                .foregroundColor(.blue)
                                        )
                                }
                            }
                    }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding(.bottom, 40)
                )
        }
        .frame(height: 200)
        .padding(.top, -250)
    }
}

#Preview {
    @State var state: CGFloat = 0
    HomePage(scrollAddField: $state)
        .environmentObject(MainViewModel())
}
