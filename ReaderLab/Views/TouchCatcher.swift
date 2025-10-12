import SwiftUI

final class TouchCatcherView: UIView {
    var onTouchEnded: ((CGPoint) -> Void)?

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: nil) // координаты относительно экрана
            onTouchEnded?(point)
        }
        super.touchesEnded(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: nil)
            onTouchEnded?(point)
        }
        super.touchesCancelled(touches, with: event)
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // Очень важно: возвращаем false, чтобы не мешать взаимодействию с UI
        return false
    }
}

struct GlobalTouchOverlay: UIViewRepresentable {
    var onTouchEnded: (CGPoint) -> Void

    func makeUIView(context: Context) -> TouchCatcherView {
        let view = TouchCatcherView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        view.onTouchEnded = onTouchEnded
        return view
    }

    func updateUIView(_ uiView: TouchCatcherView, context: Context) {}
}


extension View {
    func addGlobalTouchListener(onTouchEnded: @escaping (CGPoint) -> Void) -> some View {
        self.onAppear {
            if let window = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
                .first {

                let overlay = TouchCatcherView(frame: window.bounds)
                overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                overlay.onTouchEnded = onTouchEnded
                window.addSubview(overlay)
            }
        }
    }
}

