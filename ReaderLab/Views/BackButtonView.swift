import SwiftUI

struct BackButtonView: View {
    let callback: () -> Void
    
    var body: some View {
        Button{
            callback()
        }label:{
            Circle()
                .fill(.black.opacity(0.5))
                    .mask(
                        ZStack{
                            Rectangle()
                            ZStack{
                                Rectangle()
                                    .foregroundColor(.black)
                                    .mask(
                                        ZStack{
                                            Rectangle()
                                            Rectangle()
                                                .padding(.top, 5)
                                                .padding(.leading, 5)
                                                .blendMode(.destinationOut)
                                        }
                                    )
                                    .cornerRadius(5)
                            }
                            .frame(width: 20, height: 20)
                            .rotationEffect(Angle(degrees: -45))
                            
                                .blendMode(.destinationOut)
                            .padding(.leading, 7)
                        }
                    )
                            
        }
        .frame(width: .maxEdge(5), height: .maxEdge(5))
    }
}

#Preview {
    BackButtonView(callback: {})
}

