import SwiftUI

struct JournalView: View {
    @ObservedObject var vm: JournalViewModel
    @State private var showingAdd = false
    @State private var selectedEntry: JournalEntry?

    var body: some View {
        NavigationView {
            ZStack {
                Frost.bg.ignoresSafeArea()

                if vm.entries.isEmpty {
                    journalEmptyState
                } else {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(vm.entries) { entry in
                                JournalRowView(entry: entry)
                                    .onTapGesture { selectedEntry = entry }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .padding(.bottom, 70)
                    }
                }
            }
            .navigationTitle("Fishing Journal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAdd = true }) {
                        Text("Add")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Frost.iceAccent)
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddJournalEntryView(vm: vm)
            }
            .sheet(item: $selectedEntry) { entry in
                JournalEntryDetailView(entry: entry, vm: vm)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private var journalEmptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            ZStack {
                Circle()
                    .fill(Frost.iceLight)
                    .frame(width: 80, height: 80)
                JournalIcon()
                    .stroke(Frost.textSecondary.opacity(0.4), style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
                    .frame(width: 36, height: 36)
            }
            Text("No journal entries yet")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Frost.textPrimary)
            Text("Tap Add to log your first\nice fishing trip.")
                .font(.system(size: 14))
                .foregroundColor(Frost.textSecondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
}

// MARK: - Journal Row

struct JournalRowView: View {
    let entry: JournalEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.formattedDate)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Frost.textPrimary)
                Spacer()
                StarRatingDisplay(rating: entry.rating)
            }
            HStack(spacing: 6) {
                TagPill(text: entry.windDirection.shortName, highlight: true)
                TagPill(text: entry.windStrength.label, highlight: false)
                TagPill(text: "\(entry.fishCaught) fish", highlight: false)
            }
            if !entry.species.isEmpty {
                Text(entry.species)
                    .font(.system(size: 12))
                    .foregroundColor(Frost.textSecondary)
                    .lineLimit(1)
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 10).fill(Frost.card))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Frost.border, lineWidth: 0.5))
    }
}

// MARK: - Star Display

struct StarRatingDisplay: View {
    let rating: Int
    var size: CGFloat = 14

    var body: some View {
        HStack(spacing: 3) {
            ForEach(1...5, id: \.self) { i in
                StarShape()
                    .fill(i <= rating ? Frost.iceAccent : Frost.border)
                    .frame(width: size, height: size)
            }
        }
    }
}

// MARK: - Star Shape

struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        let cx = rect.midX
        let cy = rect.midY
        let outerR = min(rect.width, rect.height) / 2
        let innerR = outerR * 0.4
        var p = Path()
        for i in 0..<10 {
            let r = i % 2 == 0 ? outerR : innerR
            let angle = CGFloat(Double(i) * .pi / 5 - .pi / 2)
            let pt = CGPoint(x: cx + r * cos(angle), y: cy + r * sin(angle))
            if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
        }
        p.closeSubpath()
        return p
    }
}

// MARK: - Journal Icon

struct JournalIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        // Book shape
        p.addRoundedRect(in: CGRect(x: 2, y: 0, width: w - 4, height: h), cornerSize: CGSize(width: 3, height: 3))
        // Spine
        p.move(to: CGPoint(x: w * 0.3, y: 0))
        p.addLine(to: CGPoint(x: w * 0.3, y: h))
        // Lines
        p.move(to: CGPoint(x: w * 0.42, y: h * 0.25))
        p.addLine(to: CGPoint(x: w * 0.82, y: h * 0.25))
        p.move(to: CGPoint(x: w * 0.42, y: h * 0.45))
        p.addLine(to: CGPoint(x: w * 0.75, y: h * 0.45))
        p.move(to: CGPoint(x: w * 0.42, y: h * 0.65))
        p.addLine(to: CGPoint(x: w * 0.7, y: h * 0.65))
        return p
    }
}
