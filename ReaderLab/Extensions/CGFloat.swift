import Foundation
import UIKit

extension CGFloat {
    static func width(_ percent: CGFloat) -> CGFloat {
        UIScreen.main.bounds.width * percent / 100
    }
    
    static func height(_ percent: CGFloat) -> CGFloat {
        UIScreen.main.bounds.height * percent / 100
    }
    
    static func minEdge(_ percent: CGFloat) -> CGFloat {
        let bounds = UIScreen.main.bounds
        let edge = Swift.min(bounds.width, bounds.height)
        
        return edge * percent / 100
    }
    
    static func maxEdge(_ percent: CGFloat) -> CGFloat {
        let bounds = UIScreen.main.bounds
        let edge = Swift.max(bounds.width, bounds.height)
        
        return edge * percent / 100
    }
}
