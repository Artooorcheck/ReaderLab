import SwiftUI

struct BookCardView: View {
    
    @EnvironmentObject var appearance: AppearanceViewModel
    
    @Binding var favorite: Bool
    let date: Date
    let title: String
    let status: Double
    let image: UIImage
    
    @State var translateX: CGFloat = 0
    @State var startDrag: Bool = false
    @State var startOffset: CGFloat = 0
    
    var onDelete: () -> Void
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.red)
                .overlay(
                    HStack{
                        Button{
                            withAnimation(.linear(duration: 0.2)){
                                onDelete()
                            }
                        } label: {
                            Image(uiImage: UIImage.trashCan)
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(width: .maxEdge(3), height: .maxEdge(3))
                        Spacer(minLength: 0)
                        Button{
                            withAnimation(.linear(duration: 0.2)){
                                onDelete()
                            }
                        } label: {
                            Image(uiImage: UIImage.trashCan)
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(width: .maxEdge(3), height: .maxEdge(3))
                    }
                        .padding(.horizontal, 20)
                )
                .opacity(opacity())
            RoundedRectangle(cornerRadius: .maxEdge(2))
                .fill(appearance.cardColor)
                .shadow(radius: 3)
                .overlay(
                    HStack{
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: .maxEdge(14), height: .maxEdge(14))
                            .cornerRadius(.maxEdge(1))
                            .clipped()
                            .padding(.leading, .maxEdge(1))
                        VStack(alignment: .leading){
                            HStack(alignment: .top){
                                VStack(alignment: .leading){
                                    Text(title)
                                        .multilineTextAlignment(.leading)
                                        .font(.system(size: .maxEdge(2)))
                                        .frame(height: .maxEdge(6))
                                    Spacer(minLength: 0)
                                    HStack{
                                        Text(formatDate(date))
                                            .font(.system(size: .maxEdge(1.4)))
                                            .bold()
                                    }
                                    
                                }
                                .foregroundColor(appearance.textColor)
                                Spacer(minLength: 0)
                                Button {
                                    favorite.toggle()
                                } label: {
                                    ZStack {
                                        StarShape()
                                            .frame(width: .maxEdge(4.5), height: .maxEdge(4.5))
                                            .mask(
                                                Circle()
                                                    .padding(4)
                                            )
                                            .foregroundColor(favorite ? .yellow : .white)
                                            .shadow(radius: 2)
                                    }
                                }
                                .padding(.top, .maxEdge(1))
                            }
                            SliderView(value: status)
                                .frame(height: .maxEdge(4))
                        }
                        .padding(.vertical, 7)
                        .padding(.trailing, 10)
                    }
                )
                .padding(.horizontal, 15)
                .transformEffect(.init(translationX: translateX, y: 0))
        }
        .simultaneousGesture(DragGesture()
            .onChanged { input in
                if(!startDrag) {
                    startOffset = translateX
                    startDrag = true
                }
                translateX = input.translation.width + startOffset
            }
            .onEnded { input in
                withAnimation(.linear(duration: 0.2)){
                    let sign = translateX / abs(translateX)
                    if(abs(translateX) < .maxEdge(8)) {
                        translateX = 0
                    } else if abs(translateX) < .maxEdge(16) {
                        translateX = .maxEdge(8) * sign
                    } else {
                        translateX = UIScreen.main.bounds.width * sign
                        onDelete()
                    }
                }
                startDrag = false
            })
        .frame(height: .maxEdge(16))
    }
    
    func formatDate(_ date: Date) -> String {
        return "\(date.formatted(.dateTime.month(.abbreviated).day())), \(date.formatted(.dateTime.year()))"
    }
    
    func opacity() -> CGFloat {
        return 1 - abs(1 - abs(translateX / .maxEdge(8)))
    }
}


#Preview {
    @State var favorite = false
    BookCardView(favorite: $favorite, date: Date(), title: "How yuo cen create a magic item in D&D", status: 0.5, image: UIImage.IMG_0092, onDelete: {})
        .environmentObject(AppearanceViewModel(.dark))
}
