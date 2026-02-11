import SwiftUI

struct HelpView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ZStack {
                Frost.bg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 18) {
                        infoCard(
                            title: "How Wind Affects Fishing",
                            body: "Wind pushes surface water, plankton, and debris to the downwind shore. Baitfish follow the plankton, and predators follow baitfish. The downwind side becomes the prime feeding zone."
                        )

                        infoCard(
                            title: "Water Temperature Layers",
                            body: "On the downwind side, warmer surface water piles up, raising activity. The windward side gets cooler upwelling water from below. Fish prefer the warmer accumulation zone."
                        )

                        infoCard(
                            title: "Ice Fishing & Wind",
                            body: "Even under ice, wind creates currents that distribute oxygen and nutrients. Drill your holes on the downwind side for better odds. Wind also affects your comfort — use the shelter advisor."
                        )

                        infoCard(
                            title: "Wind Chill on Ice",
                            body: "The wind chill calculator shows the effective temperature your body feels. At -10 C with strong wind, it can feel like -25 C. Dress accordingly and position your shelter to block the wind."
                        )

                        infoCard(
                            title: "Shelter Positioning",
                            body: "Place your ice shelter on the downwind shore with the opening away from the wind. This gives you both the best fishing spot and wind protection. The app recommends exact positioning."
                        )

                        faqSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                }
            }
            .navigationTitle("Information")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { presentationMode.wrappedValue.dismiss() }
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Frost.iceAccent)
                }
            }
        }
        .preferredColorScheme(.light)
    }

    private func infoCard(title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Frost.textPrimary)

            Text(body)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(Frost.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Frost.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Frost.border, lineWidth: 0.5)
        )
    }

    private var faqSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("FAQ")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Frost.textPrimary)

            FaqRow(q: "Does wind direction change during the day?",
                   a: "Yes. Re-analyze when you notice a shift. Fish may take 1-2 hours to reposition after a major change.")

            FaqRow(q: "What about very strong winds?",
                   a: "In gale conditions fish often retreat to deeper water. Safety comes first — consider postponing your trip.")

            FaqRow(q: "Is this method reliable for all species?",
                   a: "Most effective for species that chase plankton and baitfish. Bottom feeders are less influenced by wind patterns.")

            FaqRow(q: "How accurate is the wind chill reading?",
                   a: "It uses the standard meteorological formula (Environment Canada). Accuracy depends on entering the correct air temperature.")
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Frost.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Frost.border, lineWidth: 0.5)
        )
    }
}

private struct FaqRow: View {
    let q: String
    let a: String
    @State private var open = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button(action: { withAnimation(.easeInOut(duration: 0.2)) { open.toggle() } }) {
                HStack {
                    Text(q)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Frost.textPrimary)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    FaqChevron(open: open)
                        .stroke(Frost.textSecondary, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
                        .frame(width: 10, height: 10)
                }
            }

            if open {
                Text(a)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Frost.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 2)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Frost.iceLight.opacity(0.5))
        )
    }
}

private struct FaqChevron: Shape {
    let open: Bool

    func path(in rect: CGRect) -> Path {
        var p = Path()
        if open {
            p.move(to: CGPoint(x: 0, y: rect.height * 0.7))
            p.addLine(to: CGPoint(x: rect.midX, y: rect.height * 0.3))
            p.addLine(to: CGPoint(x: rect.width, y: rect.height * 0.7))
        } else {
            p.move(to: CGPoint(x: 0, y: rect.height * 0.3))
            p.addLine(to: CGPoint(x: rect.midX, y: rect.height * 0.7))
            p.addLine(to: CGPoint(x: rect.width, y: rect.height * 0.3))
        }
        return p
    }
}
