import Foundation
import SQLite
import SwiftUI

final class DatabaseManager {
    private let db: Connection

    private let books: BooksTable
    private let images: ImagesTable
    
    init() throws {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbURL = docs.appendingPathComponent("app.sqlite3")
        db = try Connection(dbURL.path)

        try db.execute("PRAGMA journal_mode = WAL;")
        db.busyTimeout = 3.0
        
        books = try BooksTable(connection: db)
        images = try ImagesTable(connection: db)
    }
    
    func get(limit: Int) throws -> [BookModel] {
        return try self.books.get(limit: limit)
    }
    
    func setPreviewAsync(id: Int64, setImage: (UIImage) -> Void) async throws {
        let images = try self.images.get(bookId: id)
        await MainActor.run {
            setImage(images[0])
        }
    }
    
    func getBooksCount() throws -> Int {
        return try books.getCount()
    }
    
    func save(book: BookModel) throws -> Int64 {
        var bookId: Int64 = -1
        try db.transaction {
            bookId = try self.books.add(book: book)
            if let image = book.image {
                try self.images.add(image: image, bookId: bookId)
            }
        }
        return bookId
    }
        
    func update(book: BookModel) throws {
        try self.books.update(book: book)
    }
    
    func delete(id: Int64) throws {
        try self.books.delete(id: id)
    }
}
