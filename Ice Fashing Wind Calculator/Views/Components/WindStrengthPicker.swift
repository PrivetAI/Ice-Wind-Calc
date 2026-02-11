import SwiftUI

struct WindStrengthPicker: View {
    @Binding var selected: WindStrength

    var body: some View {
        HStack(spacing: 6) {
            ForEach(WindStrength.allCases, id: \.self) { s in
                StrengthChip(strength: s, isActive: selected == s)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selected = s
                        }
                    }
            }
        }
    }
}

private struct StrengthChip: View {
    let strength: WindStrength
    let isActive: Bool

    var body: some View {
        VStack(spacing: 4) {
            // Bar indicator
            HStack(spacing: 2) {
                ForEach(0..<5, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 1)
                        .fill(i <= strength.orderIndex
                              ? (isActive ? Frost.iceAccent : Frost.textSecondary.opacity(0.4))
                              : Frost.border)
                        .frame(width: 3, height: CGFloat(4 + i * 2))
                }
            }
            .frame(height: 16)

            Text(strength.label)
                .font(.system(size: 10, weight: isActive ? .bold : .regular))
                .foregroundColor(isActive ? Frost.iceAccent : Frost.textSecondary)
                .lineLimit(1)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isActive ? Frost.iceLight : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isActive ? Frost.iceMid : Frost.border, lineWidth: isActive ? 1.5 : 0.5)
        )
    }
}
