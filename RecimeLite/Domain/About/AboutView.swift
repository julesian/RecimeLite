import SwiftUI

struct AboutView: View {
    enum Constants {
        static let bottomContentInset = 140.0
        static let contentInset = 12.0
        static let titleSwapThreshold = 44.0
    }
    
    @StateObject private var viewModel: AboutViewModel
    @State private var contentOffsetY = 0.0

    init() {
        _viewModel = StateObject(wrappedValue: AboutViewModel())
    }

    init(viewModel: AboutViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            BrandNavigationBarView(
                title: viewModel.title,
                showsTitle: showsProfileTitleInHeader
            )

            contentView
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .background(Color.backgroundPrimary)
        .ignoresSafeArea(.container, edges: .bottom)
    }

    @ViewBuilder
    private var contentView: some View {
        if let cvURL = viewModel.cvURL {
            PDFDocumentView(
                url: cvURL,
                contentInset: UIEdgeInsets(
                    top: Constants.contentInset,
                    left: 0,
                    bottom: Constants.bottomContentInset + Constants.contentInset,
                    right: 0
                ),
                onContentOffsetChange: { contentOffsetY = $0 }
            )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, Constants.contentInset)
                .background(Color.backgroundPrimary)
        } else {
            ContentUnavailableView(
                viewModel.unavailableTitle,
                systemImage: "doc.richtext",
                description: Text(viewModel.unavailableDescription)
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundPrimary)
        }
    }

    private var showsProfileTitleInHeader: Bool {
        contentOffsetY >= Constants.titleSwapThreshold
    }
}

#Preview {
    AboutView()
}
