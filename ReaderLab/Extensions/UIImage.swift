import SwiftUI

extension UIImage{
    var base64: String? {
        self.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
    
    
    static func fromBase64(data: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: data, options: .ignoreUnknownCharacters) else { return nil }
        return UIImage(data: imageData)
    }
    
    func fixedOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: self.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage ?? self
    }
}