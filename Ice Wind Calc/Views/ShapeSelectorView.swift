import SwiftUI

struct ShapeSelectorView: View {
    @Binding var selectedShape: WaterBodyShape
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Select the shape that matches your fishing spot")
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(Color(hex: "8A9AAC"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(WaterBodyShape.allCases, id: \.self) { shape in
                            ShapeCard(
                                shape: shape,
                                isSelected: selectedShape == shape
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedShape = shape
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    isPresented = false
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .background(Color(hex: "0A1218").ignoresSafeArea())
            .navigationTitle("Water Body Shape")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                    .foregroundColor(Color(hex: "4A90E2"))
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct ShapeCard: View {
    let shape: WaterBodyShape
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            WaterBodyShape_Drawing(shape: shape)
                .stroke(isSelected ? Color(hex: "4A90E2") : Color(hex: "4A5A6C"), lineWidth: 2)
                .background(
                    WaterBodyShape_Drawing(shape: shape)
                        .fill(Color(hex: "1A3A5C").opacity(isSelected ? 0.6 : 0.3))
                )
                .frame(height: 80)
                .padding(.horizontal, 10)
                .padding(.top, 10)
            
            VStack(spacing: 4) {
                Text(shape.displayName)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(shape.description)
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(Color(hex: "6A7A8C"))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "151D26"))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color(hex: "4A90E2") : Color(hex: "2A3A4C"), lineWidth: isSelected ? 2 : 1)
        )
        .shadow(color: isSelected ? Color(hex: "4A90E2").opacity(0.3) : .clear, radius: 8)
    }
}
