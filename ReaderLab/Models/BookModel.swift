import Foundation
import UIKit

struct BookModel: Identifiable, Hashable {
    var id: Int64
    var title: String
    var date: Date
    var favorite: Bool
    var status: Double
    var image: UIImage? = nil
    var path: URL? = nil
}
