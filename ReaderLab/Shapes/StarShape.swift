import SwiftUI

struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        var point = circlePoint(at: -90, radius: rect.width/2)
        path.move(to: CGPoint(x: rect.midX + point.x, y: rect.midY + point.y))
        point = circlePoint(at: 144 - 90, radius: rect.width/2)
        path.addLine(to: CGPoint(x: rect.midX + point.x, y: rect.midY + point.y))
        point = circlePoint(at: 288 - 90, radius: rect.width/2)
        path.addLine(to: CGPoint(x: rect.midX + point.x, y: rect.midY + point.y))
        point = circlePoint(at: 72 - 90, radius: rect.width/2)
        path.addLine(to: CGPoint(x: rect.midX + point.x, y: rect.midY + point.y))
        point = circlePoint(at: 216 - 90, radius: rect.width/2)
        path.addLine(to: CGPoint(x: rect.midX + point.x, y: rect.midY + point.y))
        point = circlePoint(at: -90, radius: rect.width/2)
        path.addLine(to: CGPoint(x: rect.midX + point.x, y: rect.midY + point.y))
        return path
    }
    
    
    private func circlePoint(at angle: CGFloat, radius: CGFloat) -> CGPoint {
        CGPoint(x: cos(angle * .pi / 180) * radius, y: sin(angle * .pi / 180) * radius)
    }
}

#Preview {
    StarShape()
}
