import Foundation
import PDFKit
import UIKit

class MainViewModel: ObservableObject {
    let pages: [String] = [
        "Home",
        "Books",
        "Favorits",
        "Completed"
    ]
    
    @Published private(set) var selectedPage: Int = 0
    
    @Published private var books: [BookModel] = []
    
    @Published var selectedBook: BookModel?
    
    @Published var addBook: Bool = false
    
    @Published var searchText: String = ""
    
    @Published var reloadId = UUID()
    
    let dbManager: DatabaseManager
    
    var filteredBooks: [BookModel] {
        let books = books.filter { item in
            return (searchText.isEmpty || item.title.lowercased().contains(searchText.lowercased()))
                && (selectedPage != 3 || item.status == 1)
                && (selectedPage != 2 || item.favorite)
        }.sorted{ b1, b2 in
            if(selectedPage == 0) {
                return b1.date > b2.date
            }
            return b1.title < b2.title
        }
        
        if(selectedPage != 0 || books.count < 4) {
            return books
        }
        return Array(books[0..<4])
    }
    
    init () {
        dbManager = try! DatabaseManager()
        
        load()
    }
    
    func selectPage(index: Int) {
        self.selectedPage = index
    }
    
    func load(){
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        DispatchQueue.global().async { [weak self] in
            let result = try? self?.dbManager.get(limit: .max).map { book in
                print("\(book.id): \(book.favorite) \(book.status)")
                return BookModel(id: book.id, title: book.title, date: book.date, favorite: book.favorite, status: book.status, image: book.image, path: cachesDirectory.appendingPathComponent("\(book.id).pdf"))
            }
            
            DispatchQueue.main.async {
                if let books = result {
                    self?.books = books
                    
                    Task {
                        for i in 0..<(result?.count ?? 0) {
                            try? await Task.sleep(nanoseconds: 10_000_000)
                            if let book = result?[i] {
                                try? await self?.dbManager.setPreviewAsync(id: book.id){ image in
                                    self?.books[i].image = image
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func setFavorite(id: Int64) {
        let index = books.firstIndex(where: {$0.id == id})
        if let i = index {
            books[i].favorite = !books[i].favorite
            let book = books[i]
            DispatchQueue.global().async { [weak self] in
                try! self?.dbManager.update(book: book)
            }
        }
    }
    
    func setProgress(value: Double) {
        let index = books.firstIndex(where: {$0.id == selectedBook?.id})
        if let i = index {
            books[i].status = value
            books[i].date = Date()
            let book = books[i]
            reloadId = UUID()
            DispatchQueue.global().async { [weak self] in
                try! self?.dbManager.update(book: book)
            }
        }
    }
    
    func deleteBook(id: Int64) {
        let index = books.firstIndex(where: {$0.id == id})
        if let i = index {
            print(i)
            books.remove(at: i)
            reloadId = UUID()
            DispatchQueue.global().async { [weak self] in
                try! self?.dbManager.delete(id: id)
            }
        }
    }

    func generatePDFThumbnail(from url: URL, size: CGSize) -> UIImage? {
        guard let document = PDFDocument(url: url),
              let page = document.page(at: 0) else {
            return nil
        }

        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.scale = UIScreen.main.scale
        let renderer = UIGraphicsImageRenderer(size: size, format: rendererFormat)

        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(CGRect(origin: .zero, size: size))

            page.draw(with: .mediaBox, to: ctx.cgContext)
        }

        return img
    }
    
    func downloadIfNeeded(url: URL, completion: @escaping (URL?) -> Void) {
        if FileManager.default.isUbiquitousItem(at: url) {
            print("Файл находится в iCloud, проверка доступности...")

            let coordinator = NSFileCoordinator()
            var error: NSError?
            coordinator.coordinate(readingItemAt: url, options: [], error: &error) { (newURL) in
                if FileManager.default.fileExists(atPath: newURL.path) {
                    completion(newURL)
                } else {
                    print("Файл не существует после координации")
                    completion(nil)
                }
            }

            if let error = error {
                print("Ошибка координации файла:", error)
                completion(nil)
            }
        } else {
            print("Файл уже локален")
            completion(url)
        }
    }
    
    func addFile(url: URL, openBook: Bool = false) {
        self.downloadIfNeeded(url: url) { localURL in
            guard let localURL = localURL else {
                print("Не удалось загрузить файл локально")
                return
            }
            self.fileSelected(url: localURL, openBook: openBook)
        }
    }
    
    func selectLastBook() {
        let book = self.books.sorted(by: { b1, b2 in
            b1.date > b2.date
        }).first
        
        if let lastBook = book {
            self.selectedBook = lastBook
        }
    }
    
    func fileSelected(url: URL, openBook: Bool = false) {
        let fileName = url.lastPathComponent
        
        var book = BookModel(id: -1, title: fileName, date: Date(), favorite: false, status: 0, image: self.generatePDFThumbnail(from: url, size: CGSize(width: 150, height: 150)), path: url)
        
        book.id = try! self.dbManager.save(book: book)

        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let destinationURL = cachesDirectory.appendingPathComponent("\(book.id).pdf")

        do {
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }

            try FileManager.default.copyItem(at: url, to: destinationURL)
            print("Файл скопирован в кэш:", destinationURL.path)

            DispatchQueue.main.async {
                self.addBook = false
                
                if FileManager.default.fileExists(atPath: book.path?.path ?? "") {
                    self.books.append(book)
                    if(openBook) {
                        self.selectedBook = book
                    }
                    print("Файл \(url.path) в Кэше")
                }
            }

        } catch {
            print("Ошибка копирования файла:", error)
        }
    }
}
