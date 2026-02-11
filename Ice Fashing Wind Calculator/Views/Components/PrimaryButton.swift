import SwiftUI

// This file is intentionally minimal. The primary action button is inlined
// in ContentView to keep the single-page design self-contained.
// Keeping the file so the Xcode project reference stays valid.

struct FrostActionButton: View {
    let label: String
    let enabled: Bool
    let action: () -> Void

    init(_ label: String, enabled: Bool = true, action: @escaping () -> Void) {
        self.label = label
        self.enabled = enabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 46)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                colors: enabled
                                    ? [Frost.iceAccent, Frost.iceMid]
                                    : [Frost.border, Frost.border],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
        }
        .disabled(!enabled)
    }
}
