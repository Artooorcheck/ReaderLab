import SwiftUI

struct SettingsPage: View {
    
    @EnvironmentObject var appearance: AppearanceViewModel
    @Binding var isPresented: Bool
    
    
    var body: some View {
        NavigationStack {
            VStack{
                VStack(alignment: .leading, spacing: .maxEdge(2.1)){
                    Text("Color Scheme")
                        .font(.system(size: .maxEdge(2.1)))
                        .foregroundColor(appearance.textColor)
                    ColorSchemeSelectorView()
                }
                .padding(.maxEdge(2.1))
                .background(
                    RoundedRectangle(cornerRadius: .maxEdge(1.5))
                        .foregroundColor(appearance.cardColor)
                        .shadow(radius: 2)
                )
                VStack(alignment: .leading, spacing: .maxEdge(2.1)){
                    Text("Scroll Direction")
                        .font(.system(size: .maxEdge(2.1)))
                        .foregroundColor(appearance.textColor)
                    PageSeparatorSelectorView()
                }
                .padding(.maxEdge(2.1))
                .background(
                    RoundedRectangle(cornerRadius: .maxEdge(1.5))
                        .foregroundColor(appearance.cardColor)
                        .shadow(radius: 2)
                )
                Spacer(minLength: 0)
            }
            .padding(.top, 10)
            .frame(maxHeight: .infinity)
            .padding(.horizontal, 10)
            .background(appearance.backgroundColor)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isPresented = false
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .semibold))
                            Text("Back")
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme((appearance.appearance == .light ? .light : .dark), for: .navigationBar)
        }
    }
}

#Preview {
    @State var isPrsesented = true
    SettingsPage(isPresented: $isPrsesented)
        .environmentObject(AppearanceViewModel())
}
