import SwiftUI


struct HomePage: View {
    @EnvironmentObject var vm: MainViewModel
    @EnvironmentObject var appearance: AppearanceViewModel
    @Binding var scrollAddField: CGFloat
    @State var selectFile: Bool = false
    
    var body: some View {
        ScrollView{
            VStack(spacing: .maxEdge(2)){
                AddFieldView(active: $vm.addBook, scrollY: $scrollAddField)
                VStack(spacing: .maxEdge(2)){
                    ForEach(vm.filteredBooks){ item in
                        Button{
                            vm.selectedBook = item
                        } label: {
                            BookCardView(favorite:Binding(
                                get: { item.favorite },
                                set: { _ in vm.setFavorite(id: item.id) }
                            ), date: Date(), title: item.title, status: item.status, image: item.image ?? UIImage.placeholder, onDelete: {
                                vm.deleteBook(id: item.id)
                            })
                        }
                    }
                }
                .padding(.top, .maxEdge(10))
            }
        }
        .id(vm.reloadId)
        .scrollIndicators(.hidden)
        .fullScreenCover(isPresented: $vm.addBook){
            FilePickerView()
        }
        .fullScreenCover(item: $vm.selectedBook){ book in
            PdfPage(url: book.path, state: book.status, book: $vm.selectedBook)
        }
    }
}

#Preview {
    @State var state: CGFloat = 0
    HomePage(scrollAddField: $state)
        .environmentObject(MainViewModel())
        .environmentObject(AppearanceViewModel(.dark))
}
