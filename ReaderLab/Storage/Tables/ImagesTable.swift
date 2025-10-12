import Foundation
import SwiftUI
import SQLite

final class ImagesTable {
    private let db: Connection
    let table = Table("images")
    
    let id = Expression<Int64>("id")
    let base64 = Expression<String>("base64")
    let bookId = Expression<Int64>("book_id")

    init(connection: Connection) throws {
        db = connection
        let books = try BooksTable(connection: connection)
        
        try db.run(table.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(base64)
            t.column(bookId)
            t.foreignKey(bookId, references: books.table, books.id, delete: .cascade)
        })
    }
    
    func add(image: UIImage, bookId: Int64) throws {
        try db.run(table.insert(self.base64 <- image.base64!, self.bookId <- bookId))
    }
    
    func get(bookId: Int64) throws -> [UIImage] {
        try db.prepare(table.filter(self.bookId == bookId)).map { row in
            UIImage.fromBase64(data: row[self.base64])!
        }
    }
}
