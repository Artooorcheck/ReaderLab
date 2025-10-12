import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    @EnvironmentObject var settings: SettingsViewModel
    
    let url: URL?
    @Binding var state: Double
    
    func makeCoordinator() -> Coordinator {
        Coordinator(settings: settings){ progress in
            state = progress
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        @ObservedObject var settings: SettingsViewModel
        private var lastReportedProgress: Double = -1
        let onStatusUpdate: (Double) -> Void
        
        init(settings: SettingsViewModel, onStatusUpdate: @escaping (Double) -> Void) {
            self.onStatusUpdate = onStatusUpdate
            self.settings = settings
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            var offset =  scrollView.contentOffset.y
            var total = max(scrollView.contentSize.height - scrollView.frame.height, 1)
            if(settings.pageSeparator == .horizontal) {
                offset = scrollView.contentOffset.x
                total = max(scrollView.contentSize.width - scrollView.frame.width, 1)
            }
            
            let progress = max(0, min(1, offset / total))
            
            if abs(progress - lastReportedProgress) > 0.001 {
                lastReportedProgress = progress
                onStatusUpdate(progress)
            }
        }
    }

    
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        
        pdfView.displayMode = settings.displayMode
        pdfView.displayDirection = settings.displayDirection
        
        
        if let url = url, let document = PDFDocument(url: url) {
            pdfView.document = document
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            guard let scrollView = pdfView.subviews.compactMap({ $0 as? UIScrollView }).first else { return }
            scrollView.delegate = context.coordinator
            
            let pageCount = pdfView.document?.pageCount ?? 1
            
            if pageCount <= 1 {
                state = 1
            }
            
            if(settings.pageSeparator == .horizontal) {
                let total = scrollView.contentSize.width - scrollView.frame.width
                let offsetX = total * CGFloat(state)
                scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
            } else {
                let total = scrollView.contentSize.height - scrollView.frame.height
                let offsetY = total * CGFloat(state)
                scrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: false)
            }
        }
        
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.displayMode = settings.displayMode
        uiView.displayDirection = settings.displayDirection
        if uiView.document == nil, let url = url, let document = PDFDocument(url: url) {
            uiView.document = document
        }
        
        DispatchQueue.main.async {
            if let scrollView = uiView.subviews.compactMap({ $0 as? UIScrollView }).first,
               scrollView.delegate !== context.coordinator {
                scrollView.delegate = context.coordinator
            }
        }
    }
}


// MARK: - PdfPage Wrapper
struct PdfPage: View {
    let url: URL?
    @State var state: Double
    @Binding var book: BookModel?
    @EnvironmentObject var vm: MainViewModel
    
    var body: some View {
        ZStack{
                
            PDFKitView(url: url, state: $state)
                .environmentObject(vm)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    print("Appeared -> \(url?.path ?? "")")
                }
            HStack(alignment: .center){
                BackButtonView{
                    vm.setProgress(value: state)
                    book = nil
                }
                Spacer(minLength: 0)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(30)
                
        }
        .ignoresSafeArea()
    }
}
