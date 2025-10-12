import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var vm: MainViewModel
    
    var body: some View {
        HStack(spacing: 10){
            ForEach(0..<vm.pages.count){ index in
                let tab = vm.pages[index]
                Button{
                    vm.selectPage(index: index)
                } label: {
                    VStack {
                        HStack {
                            Image(tab)
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .frame(width: 20)
                                .foregroundColor(vm.selectedPage != index ? .gray.opacity(0.4) : .white)
                                .padding(.leading, vm.selectedPage != index ? 10 : 0)
                            Text(tab)
                                .font(.system(size: 12))
                                .bold()
                                .foregroundColor(vm.selectedPage != index ? .clear : .white)
                        }
                    }
                }
                .frame(width: vm.selectedPage == index ? 100 : 30, height: 20)
                .foregroundColor(.gray.opacity(0.4))
            }
        }
        .padding(15)
        .background(
            ZStack{
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(.gray)
                    .padding(2)
                    .padding(.leading, CGFloat(vm.selectedPage * 42))
                    .padding(.trailing, CGFloat((vm.pages.count - vm.selectedPage - 1) * 42))
            }
        )
        .animation(.easeOut, value: vm.selectedPage)
    }
}

#Preview {
    TabBarView()
        .environmentObject(MainViewModel())
}
