import SwiftUI

struct JournalEntryDetailView: View {
    let entry: JournalEntry
    @ObservedObject var vm: JournalViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEdit = false
    @State private var showingDeleteAlert = false

    var body: some View {
        NavigationView {
            ZStack {
                Frost.bg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 14) {
                        // Header
                        VStack(spacing: 8) {
                            Text(entry.formattedDate)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Frost.textPrimary)
                            StarRatingDisplay(rating: entry.rating)
                        }
                        .padding(.top, 8)

                        detailCard(title: "Wind Conditions") {
                            HStack(spacing: 12) {
                                TagPill(text: entry.windDirection.displayName, highlight: true)
                                TagPill(text: entry.windStrength.label, highlight: false)
                            }
                        }

                        detailCard(title: "Water Body") {
                            Text(entry.waterBodyShape.label)
                                .font(.system(size: 14))
                                .foregroundColor(Frost.textPrimary)
                        }

                        if let temp = entry.temperatureCelsius {
                            detailCard(title: "Temperature") {
                                Text(String(format: "%.0f C", temp))
                                    .font(.system(size: 14))
                                    .foregroundColor(Frost.textPrimary)
                            }
                        }

                        detailCard(title: "Session") {
                            HStack(spacing: 20) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Hours")
                                        .font(.system(size: 11))
                                        .foregroundColor(Frost.textSecondary)
                                    Text(String(format: "%.1f", entry.hoursFished))
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(Frost.textPrimary)
                                }
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Fish Caught")
                                        .font(.system(size: 11))
                                        .foregroundColor(Frost.textSecondary)
                                    Text("\(entry.fishCaught)")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(Frost.textPrimary)
                                }
                                if entry.hoursFished > 0 {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Per Hour")
                                            .font(.system(size: 11))
                                            .foregroundColor(Frost.textSecondary)
                                        Text(String(format: "%.1f", Double(entry.fishCaught) / entry.hoursFished))
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(Frost.iceAccent)
                                    }
                                }
                            }
                        }

                        if !entry.species.isEmpty {
                            detailCard(title: "Species") {
                                Text(entry.species)
                                    .font(.system(size: 14))
                                    .foregroundColor(Frost.textPrimary)
                            }
                        }

                        if !entry.notes.isEmpty {
                            detailCard(title: "Notes") {
                                Text(entry.notes)
                                    .font(.system(size: 14))
                                    .foregroundColor(Frost.textPrimary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }

                        // Actions
                        HStack(spacing: 14) {
                            Button(action: { showingEdit = true }) {
                                Text("Edit")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Frost.iceAccent)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Frost.iceLight)
                                    )
                            }
                            Button(action: { showingDeleteAlert = true }) {
                                Text("Delete")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Frost.dangerZone)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Frost.dangerZone, lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                }
            }
            .navigationTitle("Trip Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { presentationMode.wrappedValue.dismiss() }
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Frost.iceAccent)
                }
            }
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("Delete Entry"),
                    message: Text("Are you sure you want to delete this journal entry?"),
                    primaryButton: .destructive(Text("Delete")) {
                        vm.delete(entry)
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
            .sheet(isPresented: $showingEdit) {
                AddJournalEntryView(vm: vm, editingEntry: entry)
            }
        }
        .preferredColorScheme(.light)
    }

    private func detailCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(Frost.textSecondary)
            content()
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 10).fill(Frost.card))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Frost.border, lineWidth: 0.5))
    }
}
