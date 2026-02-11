import SwiftUI

struct ShapeSelectorView: View {
    @Binding var selectedShape: WaterBodyShape
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            ZStack {
                Frost.bg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 14) {
                        Text("Choose the shape closest to your fishing spot")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Frost.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 8)

                        ForEach(WaterBodyShape.allCases, id: \.self) { shape in
                            ShapeOptionRow(shape: shape, isChosen: selectedShape == shape)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedShape = shape
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                        isPresented = false
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Water Body")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { isPresented = false }
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Frost.iceAccent)
                }
            }
        }
        .preferredColorScheme(.light)
    }
}

private struct ShapeOptionRow: View {
    let shape: WaterBodyShape
    let isChosen: Bool

    var body: some View {
        HStack(spacing: 14) {
            BodyOutline(shape: shape)
                .fill(Frost.iceLight)
                .overlay(BodyOutline(shape: shape).stroke(isChosen ? Frost.iceAccent : Frost.border, lineWidth: 1.5))
                .frame(width: 56, height: 40)

            VStack(alignment: .leading, spacing: 2) {
                Text(shape.label)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Frost.textPrimary)
                Text(shape.hint)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Frost.textSecondary)
            }

            Spacer()

            SelectionDot(active: isChosen)
                .frame(width: 22, height: 22)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Frost.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isChosen ? Frost.iceAccent.opacity(0.6) : Frost.border, lineWidth: isChosen ? 1.5 : 0.5)
        )
    }
}

private struct SelectionDot: View {
    let active: Bool

    var body: some View {
        ZStack {
            Circle()
                .stroke(active ? Frost.iceAccent : Frost.border, lineWidth: 1.5)
            if active {
                Circle()
                    .fill(Frost.iceAccent)
                    .padding(5)
            }
        }
    }
}
