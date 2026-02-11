import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsVM: SettingsViewModel
    @State private var showResetAlert = false

    var body: some View {
        NavigationView {
            ZStack {
                Frost.bg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 14) {
                        // Temperature Unit
                        settingsCard(title: "Temperature Unit") {
                            Picker("", selection: $settingsVM.settings.temperatureUnit) {
                                ForEach(TemperatureUnit.allCases, id: \.self) { unit in
                                    Text(unit.label).tag(unit)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .onChange(of: settingsVM.settings.temperatureUnit) { _ in settingsVM.save() }
                        }

                        // Wind Speed Unit
                        settingsCard(title: "Wind Speed Unit") {
                            Picker("", selection: $settingsVM.settings.windSpeedUnit) {
                                ForEach(WindSpeedUnit.allCases, id: \.self) { unit in
                                    Text(unit.label).tag(unit)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .onChange(of: settingsVM.settings.windSpeedUnit) { _ in settingsVM.save() }
                        }

                        // Default Water Body
                        settingsCard(title: "Default Water Body") {
                            VStack(spacing: 6) {
                                ForEach(WaterBodyShape.allCases, id: \.self) { shape in
                                    HStack {
                                        Text(shape.label)
                                            .font(.system(size: 14))
                                            .foregroundColor(Frost.textPrimary)
                                        Spacer()
                                        if settingsVM.settings.defaultWaterBody == shape {
                                            Circle()
                                                .fill(Frost.iceAccent)
                                                .frame(width: 8, height: 8)
                                        }
                                    }
                                    .padding(.vertical, 6)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        settingsVM.settings.defaultWaterBody = shape
                                        settingsVM.save()
                                    }
                                }
                            }
                        }

                        // Reset Data
                        Button(action: { showResetAlert = true }) {
                            Text("Reset All Data")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Frost.dangerZone)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Frost.dangerZone, lineWidth: 1)
                                )
                        }
                        .padding(.top, 8)

                        // App Version
                        VStack(spacing: 4) {
                            Text("Ice Fashing Wind Calculator")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(Frost.textSecondary)
                            Text("Version 1.0")
                                .font(.system(size: 12))
                                .foregroundColor(Frost.textSecondary.opacity(0.7))
                        }
                        .padding(.top, 16)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .padding(.bottom, 70)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showResetAlert) {
                Alert(
                    title: Text("Reset All Data"),
                    message: Text("This will delete all journal entries, analysis history, and reset settings to defaults. This cannot be undone."),
                    primaryButton: .destructive(Text("Reset")) {
                        settingsVM.resetAllData()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func settingsCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(Frost.textSecondary)
            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 10).fill(Frost.card))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Frost.border, lineWidth: 0.5))
    }
}
