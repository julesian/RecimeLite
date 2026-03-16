import PDFKit
import SwiftUI

struct PDFDocumentView: UIViewRepresentable {
    enum Constants {
        static let initialScaleMultiplier = 0.9
    }

    let url: URL
    let contentInset: UIEdgeInsets
    let onContentOffsetChange: ((CGFloat) -> Void)?

    init(
        url: URL,
        contentInset: UIEdgeInsets = .zero,
        onContentOffsetChange: ((CGFloat) -> Void)? = nil
    ) {
        self.url = url
        self.contentInset = contentInset
        self.onContentOffsetChange = onContentOffsetChange
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onContentOffsetChange: onContentOffsetChange)
    }

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.displaysPageBreaks = false
        pdfView.usePageViewController(false)
        pdfView.backgroundColor = .clear
        pdfView.document = PDFDocument(url: url)
        DispatchQueue.main.async {
            applyConfiguration(to: pdfView, coordinator: context.coordinator)
        }
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        if uiView.document?.documentURL != url {
            uiView.document = PDFDocument(url: url)
        }

        DispatchQueue.main.async {
            applyConfiguration(to: uiView, coordinator: context.coordinator)
        }
    }

    private func applyInitialScale(to pdfView: PDFView) {
        let fittedScale = pdfView.scaleFactorForSizeToFit
        let adjustedScale = fittedScale * Constants.initialScaleMultiplier

        pdfView.minScaleFactor = adjustedScale
        pdfView.scaleFactor = adjustedScale
    }

    private func applyConfiguration(
        to pdfView: PDFView,
        coordinator: Coordinator
    ) {
        applyInitialScale(to: pdfView)

        guard let scrollView = pdfView.subviews.compactMap({ $0 as? UIScrollView }).first else {
            return
        }

        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = coordinator
    }
}

extension PDFDocumentView {
    final class Coordinator: NSObject, UIScrollViewDelegate {
        let onContentOffsetChange: ((CGFloat) -> Void)?

        init(onContentOffsetChange: ((CGFloat) -> Void)?) {
            self.onContentOffsetChange = onContentOffsetChange
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            onContentOffsetChange?(scrollView.contentOffset.y)
        }
    }
}
