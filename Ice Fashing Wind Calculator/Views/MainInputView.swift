import SwiftUI

struct MainInputView: View {
    @ObservedObject var viewModel: AppViewModel
    @Binding var selectedTab: Int
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Ice Fashing Wind Calculator")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Find the best fishing spots")
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(Color(hex: "8A9AAC"))
                }
                .padding(.top, 20)
                
                // Wind Direction Section
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Wind Direction", subtitle: "Tap on compass to select")
                    
                    CompassView(selectedDirection: $viewModel.selectedWindDirection)
                        .frame(height: 280)
                        .padding(.horizontal, 20)
                }
                
                // Wind Strength Section
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Wind Strength", subtitle: "Select intensity")
                    
                    WindStrengthPicker(selectedStrength: $viewModel.selectedWindStrength)
                        .padding(.horizontal, 20)
                }
                
                // Calculate Button
                PrimaryButton(title: "Show Feeding Zones") {
                    viewModel.calculateAndSave()
                    withAnimation {
                        selectedTab = 1
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .background(Color(hex: "0A1218").ignoresSafeArea())
    }
}

struct SectionHeader: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            
            Text(subtitle)
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(Color(hex: "6A7A8C"))
        }
        .padding(.horizontal, 20)
    }
}
