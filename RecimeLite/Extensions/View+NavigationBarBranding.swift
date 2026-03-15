import SwiftUI

extension View {
    func styleWithBrand() -> some View {
        navigationTitle(" ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image(.appLogoText)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 22)
                        .foregroundStyle(.accentBlue)
                }
            }
            .toolbarBackground(.foregroundPrimary, for: .navigationBar)
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
    }
}
