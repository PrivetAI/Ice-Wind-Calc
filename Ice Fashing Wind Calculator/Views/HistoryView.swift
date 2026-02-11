import SwiftUI

struct HistoryView: View {
    @ObservedObject var vm: AppViewModel

    var body: some View {
        NavigationView {
            ZStack {
                Frost.bg.ignoresSafeArea()

                if vm.records.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(vm.records) { record in
                                HistoryRowView(record: record)
                                    .onTapGesture { vm.restoreRecord(record) }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                    }
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !vm.records.isEmpty {
                        Button("Clear All") { vm.purgeAllRecords() }
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Frost.dangerZone)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { vm.showHistorySheet = false }
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Frost.iceAccent)
                }
            }
        }
        .preferredColorScheme(.light)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Frost.iceLight)
                    .frame(width: 80, height: 80)
                EmptyListIcon()
                    .stroke(Frost.textSecondary.opacity(0.4), style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
                    .frame(width: 36, height: 36)
            }

            Text("No records yet")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Frost.textPrimary)

            Text("Analyses you run will appear here\nso you can revisit them later.")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Frost.textSecondary)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

// MARK: - Empty icon

private struct EmptyListIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        // Simple lined-paper icon
        p.addRoundedRect(in: CGRect(x: 2, y: 0, width: w - 4, height: h), cornerSize: CGSize(width: 4, height: 4))
        p.move(to: CGPoint(x: w * 0.25, y: h * 0.35))
        p.addLine(to: CGPoint(x: w * 0.75, y: h * 0.35))
        p.move(to: CGPoint(x: w * 0.25, y: h * 0.55))
        p.addLine(to: CGPoint(x: w * 0.65, y: h * 0.55))
        return p
    }
}
