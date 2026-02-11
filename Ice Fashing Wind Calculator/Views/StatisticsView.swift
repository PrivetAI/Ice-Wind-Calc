import SwiftUI

struct StatisticsView: View {
    @ObservedObject var journalVM: JournalViewModel

    var body: some View {
        NavigationView {
            ZStack {
                Frost.bg.ignoresSafeArea()

                if journalVM.entries.isEmpty {
                    statsEmptyState
                } else {
                    ScrollView {
                        VStack(spacing: 14) {
                            overviewCards
                            bestConditionsCard
                            monthlyBreakdownCard
                            personalBestCard
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .padding(.bottom, 70)
                    }
                }
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: - Empty

    private var statsEmptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            ZStack {
                Circle()
                    .fill(Frost.iceLight)
                    .frame(width: 80, height: 80)
                ChartIcon()
                    .stroke(Frost.textSecondary.opacity(0.4), style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
                    .frame(width: 36, height: 36)
            }
            Text("No statistics yet")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Frost.textPrimary)
            Text("Log trips in the Journal\nto see your statistics here.")
                .font(.system(size: 14))
                .foregroundColor(Frost.textSecondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }

    // MARK: - Overview

    private var overviewCards: some View {
        let entries = journalVM.entries
        let totalTrips = entries.count
        let totalFish = entries.reduce(0) { $0 + $1.fishCaught }
        let totalHours = entries.reduce(0.0) { $0 + $1.hoursFished }
        let avgFishPerTrip = totalTrips > 0 ? Double(totalFish) / Double(totalTrips) : 0

        return VStack(spacing: 10) {
            HStack(spacing: 10) {
                statBox(label: "Total Trips", value: "\(totalTrips)")
                statBox(label: "Total Fish", value: "\(totalFish)")
            }
            HStack(spacing: 10) {
                statBox(label: "Avg Fish/Trip", value: String(format: "%.1f", avgFishPerTrip))
                statBox(label: "Total Hours", value: String(format: "%.0f", totalHours))
            }
        }
    }

    private func statBox(label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Frost.iceAccent)
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(Frost.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(RoundedRectangle(cornerRadius: 10).fill(Frost.card))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Frost.border, lineWidth: 0.5))
    }

    // MARK: - Best Conditions

    private var bestConditionsCard: some View {
        let entries = journalVM.entries

        // Best direction
        var dirFish: [WindDirection: Int] = [:]
        for e in entries { dirFish[e.windDirection, default: 0] += e.fishCaught }
        let bestDir = dirFish.max(by: { $0.value < $1.value })

        // Best strength
        var strFish: [WindStrength: Int] = [:]
        for e in entries { strFish[e.windStrength, default: 0] += e.fishCaught }
        let bestStr = strFish.max(by: { $0.value < $1.value })

        // Best temp range
        let tempsWithFish = entries.compactMap { e -> (Double, Int)? in
            guard let t = e.temperatureCelsius else { return nil }
            return (t, e.fishCaught)
        }
        let tempRange: String = {
            guard !tempsWithFish.isEmpty else { return "No data" }
            let sorted = tempsWithFish.sorted { $0.1 > $1.1 }
            let topTemps = sorted.prefix(max(1, sorted.count / 3)).map { $0.0 }
            guard let minT = topTemps.min(), let maxT = topTemps.max() else { return "No data" }
            return String(format: "%.0f to %.0f C", minT, maxT)
        }()

        return VStack(alignment: .leading, spacing: 10) {
            Text("Best Conditions")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Frost.textPrimary)

            if let bd = bestDir {
                conditionRow(label: "Wind Direction", value: "\(bd.key.displayName) (\(bd.value) fish)")
            }
            if let bs = bestStr {
                conditionRow(label: "Wind Strength", value: "\(bs.key.label) (\(bs.value) fish)")
            }
            conditionRow(label: "Temperature Range", value: tempRange)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 10).fill(Frost.card))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Frost.border, lineWidth: 0.5))
    }

    private func conditionRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(Frost.textSecondary)
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Frost.textPrimary)
        }
    }

    // MARK: - Monthly Breakdown

    private var monthlyBreakdownCard: some View {
        let entries = journalVM.entries
        let cal = Calendar.current

        // Group by month
        var monthFish: [Int: Int] = [:]
        for e in entries {
            let m = cal.component(.month, from: e.date)
            monthFish[m, default: 0] += e.fishCaught
        }

        let maxFish = monthFish.values.max() ?? 1
        let monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

        return VStack(alignment: .leading, spacing: 10) {
            Text("Monthly Breakdown")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Frost.textPrimary)

            // Only show months with data
            let activeMonths = (1...12).filter { monthFish[$0, default: 0] > 0 }

            if activeMonths.isEmpty {
                Text("No monthly data yet")
                    .font(.system(size: 13))
                    .foregroundColor(Frost.textSecondary)
            } else {
                ForEach(activeMonths, id: \.self) { month in
                    HStack(spacing: 8) {
                        Text(monthNames[month - 1])
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Frost.textSecondary)
                            .frame(width: 30, alignment: .leading)

                        GeometryReader { geo in
                            let fish = monthFish[month, default: 0]
                            let fraction = CGFloat(fish) / CGFloat(max(maxFish, 1))
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Frost.iceAccent)
                                .frame(width: max(4, geo.size.width * fraction), height: 16)
                        }
                        .frame(height: 16)

                        Text("\(monthFish[month, default: 0])")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Frost.textPrimary)
                            .frame(width: 30, alignment: .trailing)
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 10).fill(Frost.card))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Frost.border, lineWidth: 0.5))
    }

    // MARK: - Personal Best

    private var personalBestCard: some View {
        let entries = journalVM.entries
        let mostFish = entries.max(by: { $0.fishCaught < $1.fishCaught })
        let bestRated = entries.max(by: { $0.rating < $1.rating })
        let longestTrip = entries.max(by: { $0.hoursFished < $1.hoursFished })

        return VStack(alignment: .leading, spacing: 10) {
            Text("Personal Bests")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Frost.textPrimary)

            if let m = mostFish {
                personalBestRow(label: "Most Fish in a Trip", value: "\(m.fishCaught) fish", detail: m.formattedDate)
            }
            if let b = bestRated {
                personalBestRow(label: "Highest Rated Trip", value: "\(b.rating) stars", detail: b.formattedDate)
            }
            if let l = longestTrip {
                personalBestRow(label: "Longest Session", value: String(format: "%.1f hours", l.hoursFished), detail: l.formattedDate)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 10).fill(Frost.card))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Frost.border, lineWidth: 0.5))
    }

    private func personalBestRow(label: String, value: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(label)
                    .font(.system(size: 13))
                    .foregroundColor(Frost.textSecondary)
                Spacer()
                Text(value)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Frost.iceAccent)
            }
            Text(detail)
                .font(.system(size: 11))
                .foregroundColor(Frost.textSecondary.opacity(0.7))
        }
    }
}

// MARK: - Chart Icon

struct ChartIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        // Axes
        p.move(to: CGPoint(x: w * 0.15, y: h * 0.1))
        p.addLine(to: CGPoint(x: w * 0.15, y: h * 0.85))
        p.addLine(to: CGPoint(x: w * 0.9, y: h * 0.85))
        // Bars
        p.addRect(CGRect(x: w * 0.25, y: h * 0.55, width: w * 0.12, height: h * 0.3))
        p.addRect(CGRect(x: w * 0.44, y: h * 0.3, width: w * 0.12, height: h * 0.55))
        p.addRect(CGRect(x: w * 0.63, y: h * 0.45, width: w * 0.12, height: h * 0.4))
        return p
    }
}
