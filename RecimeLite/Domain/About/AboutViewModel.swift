import Foundation
import Combine

@MainActor
final class AboutViewModel: ObservableObject {
    enum Constants {
        static let cvFileName = "CV - Jules Ian Gilos"
        static let cvFileExtension = "pdf"
        static let title = "Jules Ian Gilos"
        static let unavailableTitle = "CV Unavailable"
        static let unavailableDescription = "The PDF could not be loaded from the app resources."
    }

    let cvURL: URL?
    let title: String
    let unavailableTitle: String
    let unavailableDescription: String

    init(bundle: Bundle = .main) {
        cvURL = bundle.url(
            forResource: Constants.cvFileName,
            withExtension: Constants.cvFileExtension
        )
        title = Constants.title
        unavailableTitle = Constants.unavailableTitle
        unavailableDescription = Constants.unavailableDescription
    }
}
