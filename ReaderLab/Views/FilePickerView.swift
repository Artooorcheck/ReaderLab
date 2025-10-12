import SwiftUI
import UIKit

struct FilePickerView: UIViewControllerRepresentable {
    @EnvironmentObject var vm: MainViewModel

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf], asCopy: true)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: FilePickerView
        init(_ parent: FilePickerView) { self.parent = parent }
        
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let selectedURL = urls.first else {
                print("Файл не выбран")
                return
            }

            DispatchQueue.global().async{ [weak self] in
                self?.parent.vm.addFile(url: selectedURL, openBook: true)
            }
        }



        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            print("Picker cancelled")
        }
    }
}
