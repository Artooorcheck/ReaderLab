import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var appearance: AppearanceViewModel
    @EnvironmentObject private var vm: MainViewModel
    @State var scrollAddField: CGFloat = 0
    @State private var showSettings: Bool = false
    @State private var isHovering = false
    
    var body: some View {
        ZStack{
            VStack {
                HomePage(scrollAddField: $scrollAddField)
            }
            HStack{
                SearchFieldView(text: $vm.searchText)
                Button{
                    showSettings = true
                } label : {
                    Image(uiImage: UIImage.settings1)
                        .resizable()
                }
                .frame(width: 40, height: 40)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .frame(height: 80)
            .background(
                Rectangle()
                    .fill(LinearGradient(colors: [appearance.backgroundColor, appearance.backgroundColor.opacity(0)], startPoint: .top, endPoint: .bottom))
                    .ignoresSafeArea()
            )
            .frame(maxHeight: .infinity, alignment: .top)
            .opacity(scrollAddField > .height(15) ? 1 : 0)
            .animation(.linear, value: scrollAddField)
            HStack(spacing: 30) {
                TabBarView()
                Button{
                    vm.selectLastBook()
                } label: {
                    Circle()
                        .fill(Color.orange)
                        .overlay(
                            Image("Book")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .padding(10)
                        )
                }
                .frame(width: 50, height: 50)
                .shadow(radius: 2)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
            .padding(.bottom, 20)
            
            if(isHovering) {
                GeometryReader{ geometry in
                    ZStack {
                        RoundedRectangle(cornerRadius: .minEdge(10))
                            .foregroundColor(appearance.backgroundColor)
                        RoundedRectangle(cornerRadius: .minEdge(10))
                            .stroke(style: StrokeStyle(lineWidth: 5, dash: [20, 20]))
                        VStack{
                            Image(uiImage: UIImage.books)
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("Drag & Drop PDF here")
                                .font(.system(size: .maxEdge(2)))
                        }
                    }
                    .foregroundColor(appearance.textColor)
                    .frame(width: geometry.size.width - 20, height: geometry.size.width - 20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
        }
        .background(appearance.backgroundColor)
        .onAppear{
            appearance.setAppearance(colorScheme)
        }
        .fullScreenCover(isPresented: $showSettings) {
            SettingsPage(isPresented: $showSettings)
        }
        .onDrop(of: [UTType.pdf, UTType.fileURL, UTType.data], isTargeted: $isHovering) { providers in
            handleDrop(providers: providers)
        }
    }
    
    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier(UTType.pdf.identifier) {
                provider.loadFileRepresentation(forTypeIdentifier: UTType.pdf.identifier) { url, error in
                    if let url = url {
                        let fileManager = FileManager.default
                        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                        let destURL = caches.appendingPathComponent(url.lastPathComponent)
                        
                        if fileManager.fileExists(atPath: destURL.path) {
                            try? fileManager.removeItem(at: destURL)
                        }
                        try? fileManager.copyItem(at: url, to: destURL)
                        DispatchQueue.main.async {
                            vm.selectFile(url: destURL)
                        }
                        
                    }
                }
            }
        }
        return true
    }
}

#Preview {
    ContentView()
        .environmentObject(MainViewModel())
        .environmentObject(AppearanceViewModel(.dark))
}
