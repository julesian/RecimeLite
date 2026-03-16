import SwiftUI
import UIKit

// Using UIKit here because SwiftUI's TextField was briefly dropping focus on submit,
// which made the tag-entry flow feel pretty rough. TextFields in SwiftUI is a bit painful
// to work around as per my experience T_T.
struct PersistentSubmitTextField: UIViewRepresentable {
    @Binding var text: String

    let placeholder: String
    let shouldFocus: Bool?
    let isSubmitEnabled: Bool
    let onSubmit: (() -> Void)?

    func makeCoordinator() -> Coordinator {
        Coordinator(
            text: $text,
            isSubmitEnabled: isSubmitEnabled,
            onSubmit: onSubmit
        )
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.addTarget(
            context.coordinator,
            action: #selector(Coordinator.textDidChange(_:)),
            for: .editingChanged
        )
        textField.placeholder = placeholder
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.textColor = UIColor(Color.textPrimary)
        textField.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        context.coordinator.isSubmitEnabled = isSubmitEnabled

        if uiView.text != text {
            context.coordinator.isUpdatingFromSwiftUI = true
            uiView.text = text
            context.coordinator.isUpdatingFromSwiftUI = false
        }

        if uiView.placeholder != placeholder {
            uiView.placeholder = placeholder
        }

        if let shouldFocus {
            context.coordinator.updateFocus(
                shouldFocus,
                for: uiView
            )
        }
    }
}

extension PersistentSubmitTextField {
    final class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String

        var isSubmitEnabled: Bool
        var isUpdatingFromSwiftUI = false
        var lastRequestedFocus: Bool?
        let onSubmit: (() -> Void)?

        init(
            text: Binding<String>,
            isSubmitEnabled: Bool,
            onSubmit: (() -> Void)?
        ) {
            _text = text
            self.isSubmitEnabled = isSubmitEnabled
            self.onSubmit = onSubmit
        }

        @objc
        func textDidChange(_ textField: UITextField) {
            guard !isUpdatingFromSwiftUI else { return }
            let updatedText = textField.text ?? ""

            DispatchQueue.main.async {
                self.text = updatedText
            }
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            guard isSubmitEnabled else { return false }

            onSubmit?()
            return false
        }

        func updateFocus(
            _ shouldFocus: Bool,
            for textField: UITextField
        ) {
            guard lastRequestedFocus != shouldFocus else { return }
            lastRequestedFocus = shouldFocus

            DispatchQueue.main.async {
                if shouldFocus, !textField.isFirstResponder {
                    textField.becomeFirstResponder()
                } else if !shouldFocus, textField.isFirstResponder {
                    textField.resignFirstResponder()
                }
            }
        }
    }
}
