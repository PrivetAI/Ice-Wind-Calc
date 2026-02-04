import SwiftUI

struct WindStrengthPicker: View {
    @Binding var selectedStrength: WindStrength
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(WindStrength.allCases, id: \.self) { strength in
                WindStrengthRow(
                    strength: strength,
                    isSelected: selectedStrength == strength
                )
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedStrength = strength
                    }
                }
            }
        }
    }
}

struct WindStrengthRow: View {
    let strength: WindStrength
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Wind strength indicator
            WindStrengthIndicator(level: strengthLevel)
                .frame(width: 40, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(strength.displayName)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(strength.speedRange)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(Color(hex: "8A9AAC"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(Color(hex: "2A3A4C"))
                        )
                }
                
                Text(strength.description)
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(Color(hex: "6A7A8C"))
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Selection indicator
            Circle()
                .stroke(isSelected ? Color(hex: "4A90E2") : Color(hex: "3A4A5C"), lineWidth: 2)
                .background(
                    Circle()
                        .fill(isSelected ? Color(hex: "4A90E2") : Color.clear)
                        .padding(4)
                )
                .frame(width: 24, height: 24)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color(hex: "1E2A38") : Color(hex: "151D26"))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color(hex: "4A90E2").opacity(0.5) : Color(hex: "2A3A4C"), lineWidth: 1)
        )
    }
    
    private var strengthLevel: Int {
        switch strength {
        case .weak: return 1
        case .moderate: return 2
        case .strong: return 3
        case .storm: return 4
        }
    }
}

struct WindStrengthIndicator: View {
    let level: Int
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<4, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(index < level ? strengthColor : Color(hex: "2A3A4C"))
                    .frame(width: 6, height: CGFloat(8 + index * 4))
            }
        }
    }
    
    private var strengthColor: Color {
        switch level {
        case 1: return Color(hex: "4CAF50")
        case 2: return Color(hex: "8BC34A")
        case 3: return Color(hex: "FF9800")
        case 4: return Color(hex: "F44336")
        default: return Color(hex: "4A90E2")
        }
    }
}
