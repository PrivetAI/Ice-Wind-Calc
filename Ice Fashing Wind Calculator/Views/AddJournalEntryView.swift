import SwiftUI

struct AddJournalEntryView: View {
    @ObservedObject var vm: JournalViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var date = Date()
    @State private var windDirection: WindDirection = .north
    @State private var windStrength: WindStrength = .moderate
    @State private var temperatureText = ""
    @State private var waterBody: WaterBodyShape = .circular
    @State private var hoursFishedText = ""
    @State private var fishCaughtText = ""
    @State private var species = ""
    @State private var notes = ""
    @State private var rating = 3

    var editingEntry: JournalEntry?

    var body: some View {
        NavigationView {
            ZStack {
                Frost.bg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 14) {
                        // Date
                        formCard(title: "Date") {
                            DatePicker("", selection: $date, displayedComponents: .date)
                                .labelsHidden()
                                .accentColor(Frost.iceAccent)
                        }

                        // Wind Direction
                        formCard(title: "Wind Direction") {
                            directionPicker
                        }

                        // Wind Strength
                        formCard(title: "Wind Strength") {
                            strengthPicker
                        }

                        // Water Body
                        formCard(title: "Water Body") {
                            waterBodyPicker
                        }

                        // Temperature
                        formCard(title: "Temperature (C)") {
                            TextField("e.g. -5", text: $temperatureText)
                                .keyboardType(.numbersAndPunctuation)
                                .font(.system(size: 14))
                                .foregroundColor(Frost.textPrimary)
                        }

                        // Hours Fished
                        formCard(title: "Hours Fished") {
                            TextField("e.g. 4.5", text: $hoursFishedText)
                                .keyboardType(.decimalPad)
                                .font(.system(size: 14))
                                .foregroundColor(Frost.textPrimary)
                        }

                        // Fish Caught
                        formCard(title: "Fish Caught") {
                            TextField("e.g. 12", text: $fishCaughtText)
                                .keyboardType(.numberPad)
                                .font(.system(size: 14))
                                .foregroundColor(Frost.textPrimary)
                        }

                        // Species
                        formCard(title: "Species") {
                            TextField("e.g. Walleye, Perch", text: $species)
                                .font(.system(size: 14))
                                .foregroundColor(Frost.textPrimary)
                        }

                        // Rating
                        formCard(title: "Rating") {
                            starRatingInput
                        }

                        // Notes
                        formCard(title: "Notes") {
                            ZStack(alignment: .topLeading) {
                                if notes.isEmpty {
                                    Text("Optional notes about this trip...")
                                        .font(.system(size: 14))
                                        .foregroundColor(Frost.textSecondary.opacity(0.6))
                                        .padding(.top, 8)
                                        .padding(.leading, 4)
                                }
                                TextEditor(text: $notes)
                                    .font(.system(size: 14))
                                    .foregroundColor(Frost.textPrimary)
                                    .frame(minHeight: 80)
                                    .background(Color.clear)
                            }
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                }
            }
            .navigationTitle(editingEntry == nil ? "New Entry" : "Edit Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Frost.textSecondary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveEntry() }
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Frost.iceAccent)
                }
            }
        }
        .preferredColorScheme(.light)
        .onAppear { loadEditingEntry() }
    }

    // MARK: - Direction Picker

    private var directionPicker: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 4)
        return LazyVGrid(columns: columns, spacing: 6) {
            ForEach(WindDirection.allCases, id: \.self) { dir in
                Text(dir.shortName)
                    .font(.system(size: 13, weight: windDirection == dir ? .bold : .medium))
                    .foregroundColor(windDirection == dir ? .white : Frost.textSecondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 34)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(windDirection == dir ? Frost.iceAccent : Frost.iceLight)
                    )
                    .onTapGesture { windDirection = dir }
            }
        }
    }

    // MARK: - Strength Picker

    private var strengthPicker: some View {
        VStack(spacing: 6) {
            ForEach(WindStrength.allCases, id: \.self) { s in
                HStack {
                    Text(s.label)
                        .font(.system(size: 13, weight: windStrength == s ? .bold : .medium))
                        .foregroundColor(windStrength == s ? .white : Frost.textSecondary)
                    Spacer()
                    Text(s.speedRangeText)
                        .font(.system(size: 11))
                        .foregroundColor(windStrength == s ? .white.opacity(0.8) : Frost.textSecondary.opacity(0.7))
                }
                .padding(.horizontal, 12)
                .frame(height: 34)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(windStrength == s ? Frost.iceAccent : Frost.iceLight)
                )
                .onTapGesture { windStrength = s }
            }
        }
    }

    // MARK: - Water Body Picker

    private var waterBodyPicker: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 3)
        return LazyVGrid(columns: columns, spacing: 6) {
            ForEach(WaterBodyShape.allCases, id: \.self) { shape in
                Text(shape.label)
                    .font(.system(size: 12, weight: waterBody == shape ? .bold : .medium))
                    .foregroundColor(waterBody == shape ? .white : Frost.textSecondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 34)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(waterBody == shape ? Frost.iceAccent : Frost.iceLight)
                    )
                    .onTapGesture { waterBody = shape }
            }
        }
    }

    // MARK: - Star Rating Input

    private var starRatingInput: some View {
        HStack(spacing: 8) {
            ForEach(1...5, id: \.self) { i in
                StarShape()
                    .fill(i <= rating ? Frost.iceAccent : Frost.border)
                    .frame(width: 28, height: 28)
                    .onTapGesture { rating = i }
            }
            Spacer()
        }
    }

    // MARK: - Form Card

    private func formCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Frost.textPrimary)
            content()
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 10).fill(Frost.card))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Frost.border, lineWidth: 0.5))
    }

    // MARK: - Save

    private func saveEntry() {
        let entry = JournalEntry(
            id: editingEntry?.id ?? UUID(),
            date: date,
            windDirection: windDirection,
            windStrength: windStrength,
            temperatureCelsius: Double(temperatureText),
            waterBodyShape: waterBody,
            hoursFished: Double(hoursFishedText) ?? 0,
            fishCaught: Int(fishCaughtText) ?? 0,
            species: species,
            notes: notes,
            rating: rating
        )
        vm.save(entry)
        presentationMode.wrappedValue.dismiss()
    }

    private func loadEditingEntry() {
        guard let e = editingEntry else { return }
        date = e.date
        windDirection = e.windDirection
        windStrength = e.windStrength
        if let t = e.temperatureCelsius { temperatureText = String(format: "%.0f", t) }
        waterBody = e.waterBodyShape
        hoursFishedText = String(format: "%.1f", e.hoursFished)
        fishCaughtText = "\(e.fishCaught)"
        species = e.species
        notes = e.notes
        rating = e.rating
    }
}
