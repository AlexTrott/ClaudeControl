import SwiftUI

enum CCAnimation {
    static let hover = Animation.easeInOut(duration: 0.15)
    static let stateChange = Animation.easeInOut(duration: 0.25)
    static let spring = Animation.spring(response: 0.35, dampingFraction: 0.8)
    static let listInsert = Animation.spring(response: 0.4, dampingFraction: 0.75)
    static let pulse = Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)
}

// MARK: - Pulsing Modifier

struct PulsingEffect: ViewModifier {
    let isActive: Bool
    @State private var isPulsing = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.3 : 1.0)
            .opacity(isPulsing ? 0.7 : 1.0)
            .onChange(of: isActive) { _, newValue in
                withAnimation(newValue ? CCAnimation.pulse : .default) {
                    isPulsing = newValue
                }
            }
            .onAppear {
                if isActive {
                    withAnimation(CCAnimation.pulse) {
                        isPulsing = true
                    }
                }
            }
    }
}

extension View {
    func pulsing(when active: Bool) -> some View {
        modifier(PulsingEffect(isActive: active))
    }
}
