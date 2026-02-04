import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: AppViewModel
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                Text("History")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Previous calculations")
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(Color(hex: "8A9AAC"))
            }
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            if viewModel.history.isEmpty {
                EmptyHistoryView()
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.history) { record in
                            HistoryRowView(record: record)
                                .onTapGesture {
                                    viewModel.selectHistoryRecord(record)
                                    selectedTab = 1
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        viewModel.deleteRecord(record)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "0A1218").ignoresSafeArea())
    }
}

struct EmptyHistoryView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Empty state icon
            ZStack {
                Circle()
                    .fill(Color(hex: "1E2A38"))
                    .frame(width: 100, height: 100)
                
                EmptyClockIcon()
                    .stroke(Color(hex: "4A5A6C"), lineWidth: 2)
                    .frame(width: 50, height: 50)
            }
            
            VStack(spacing: 8) {
                Text("No calculations yet")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Your calculations will appear here\nafter you analyze feeding zones")
                    .font(.system(size: 15, design: .rounded))
                    .foregroundColor(Color(hex: "6A7A8C"))
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct EmptyClockIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        // Circle
        path.addEllipse(in: CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        ))
        
        // Clock hands
        path.move(to: center)
        path.addLine(to: CGPoint(x: center.x, y: center.y - radius * 0.5))
        
        path.move(to: center)
        path.addLine(to: CGPoint(x: center.x + radius * 0.35, y: center.y + radius * 0.1))
        
        return path
    }
}
