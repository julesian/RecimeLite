import Lottie
import SwiftUI

struct LottieAnimationView: UIViewRepresentable {
    let fileName: String
    let loopMode: LottieLoopMode
    let shouldPlay: Bool

    init(
        fileName: String,
        loopMode: LottieLoopMode = .playOnce,
        shouldPlay: Bool = true
    ) {
        self.fileName = fileName
        self.loopMode = loopMode
        self.shouldPlay = shouldPlay
    }

    func makeUIView(context: Context) -> WrapperView {
        let wrapperView = WrapperView()
        let animationView = wrapperView.animationView

        animationView.animation = LottieAnimation.named(fileName)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.backgroundBehavior = .pauseAndRestore
        wrapperView.loadedFileName = fileName
        wrapperView.isPlaying = false
        wrapperView.hasPlayedOnce = false
        configurePlayback(for: wrapperView)

        return wrapperView
    }

    func updateUIView(_ uiView: WrapperView, context: Context) {
        if uiView.loadedFileName != fileName {
            uiView.animationView.animation = LottieAnimation.named(fileName)
            uiView.animationView.loopMode = loopMode
            uiView.loadedFileName = fileName
            uiView.isPlaying = false
            uiView.hasPlayedOnce = false
        }

        configurePlayback(for: uiView)
    }

    private func configurePlayback(for wrapperView: WrapperView) {
        let animationView = wrapperView.animationView

        if shouldPlay {
            guard !wrapperView.hasPlayedOnce else { return }
            guard !wrapperView.isPlaying else { return }

            wrapperView.isPlaying = true
            animationView.play { _ in
                wrapperView.isPlaying = false
                wrapperView.hasPlayedOnce = true
            }
        } else {
            guard wrapperView.isPlaying || animationView.currentProgress != 0 else { return }

            animationView.stop()
            animationView.currentProgress = 0
            wrapperView.isPlaying = false
            wrapperView.hasPlayedOnce = false
        }
    }
}

extension LottieAnimationView {
    final class WrapperView: UIView {
        let animationView = Lottie.LottieAnimationView()
        var loadedFileName: String?
        var isPlaying = false
        var hasPlayedOnce = false

        override init(frame: CGRect) {
            super.init(frame: frame)

            animationView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(animationView)

            NSLayoutConstraint.activate([
                animationView.leadingAnchor.constraint(equalTo: leadingAnchor),
                animationView.trailingAnchor.constraint(equalTo: trailingAnchor),
                animationView.topAnchor.constraint(equalTo: topAnchor),
                animationView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

#Preview {
    LottieAnimationView(fileName: "recime_splash_intro")
        .frame(width: 160, height: 160)
        .background(Color.backgroundSplash)
}
