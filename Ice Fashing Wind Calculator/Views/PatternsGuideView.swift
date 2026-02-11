import SwiftUI

struct PatternsGuideView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Frost.bg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 14) {
                        Text("Learn how wind affects ice fishing success")
                            .font(.system(size: 14))
                            .foregroundColor(Frost.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 8)

                        ForEach(WindArticleData.articles) { article in
                            ArticleCardView(article: article)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .padding(.bottom, 70)
                }
            }
            .navigationTitle("Wind Patterns Guide")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

private struct ArticleCardView: View {
    let article: WindArticle
    @State private var expanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: { withAnimation(.easeInOut(duration: 0.25)) { expanded.toggle() } }) {
                HStack {
                    Text(article.title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Frost.textPrimary)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    ExpandChevron(expanded: expanded)
                        .stroke(Frost.textSecondary, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
                        .frame(width: 12, height: 12)
                }
            }

            if expanded {
                Text(article.body)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Frost.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 2)
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 10).fill(Frost.card))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Frost.border, lineWidth: 0.5))
    }
}

private struct ExpandChevron: Shape {
    let expanded: Bool

    func path(in rect: CGRect) -> Path {
        var p = Path()
        if expanded {
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
