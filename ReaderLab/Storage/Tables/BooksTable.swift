import Foundation
import SwiftUI
import SQLite

final class BooksTable {
    private let db: Connection
    let table = Table("books")
    
    let id = Expression<Int64>("id")
    let title = Expression<String>("title")
    let favorite = Expression<Bool>("favorite")
    let date = Expression<Date>("date")
    let status = Expression<Double>("status")

    init(connection: Connection) throws {
        db = connection
        try db.run(table.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(title)
            t.column(favorite)
            t.column(date)
            t.column(status)
        })
    }
    
    func add(book: BookModel) throws -> Int64 {
        try db.run(table.insert(title <- book.title, favorite <- book.favorite, date <- Date(), status <- book.status))
    }
    
    func get(limit: Int = .max) throws -> [BookModel] {
        try db.prepare(table.order(self.date.desc).limit(limit)).map { row in
            BookModel(id: row[id], title: row[title], date: row[date], favorite: row[favorite], status: row[status])
        }
    }
    
    func getCount() throws -> Int {
        Int(try db.scalar(table.count))
    }
    
    func delete(id: Int64) throws {
        try db.run(table.filter(self.id == id).delete())
    }
    
    func update(book: BookModel) throws {
        print("\(book.id): \(book.status)")
        try db.run(table.filter(self.id == book.id).update(self.status <- book.status, self.favorite <- book.favorite, self.date <- book.date))
    }
}
