import SwiftUI

struct BreadcrumbText: View {
    let words: [String]
    let highlightedCount: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(Array(words.enumerated()), id: \.0) { index, word in
                let wordIsBlue = index < highlightedCount
                let separatorIsBlue = index < (highlightedCount - 1) 

                // Palavra
                Text(word)
                    .font(.system(size: 12, weight: wordIsBlue ? .semibold : .regular))
                    .foregroundStyle(wordIsBlue ? Color.blue : Color.black)

                // Separador (chevron)
                if index < words.count - 1 {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(separatorIsBlue ? Color.blue : Color.black.opacity(0.50))
                        .animation(.easeInOut(duration: 0.20), value: highlightedCount)
                }
            }
        }
        .animation(.easeInOut(duration: 0.20), value: highlightedCount)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }

    private var accessibilityLabel: String {
        let highlighted = words.prefix(highlightedCount).joined(separator: ", ")
        let remaining = words.dropFirst(highlightedCount).joined(separator: ", ")
        switch (highlighted.isEmpty, remaining.isEmpty) {
        case (false, false):
            return "Breadcrumb, highlighted: \(highlighted). Remaining: \(remaining)."
        case (false, true):
            return "Breadcrumb, highlighted: \(highlighted)."
        case (true, false):
            return "Breadcrumb: \(remaining)."
        default:
            return "Breadcrumb"
        }
    }
}
#if swift(>=5.9)
@available(iOS 17.0, *)
#Preview("BreadcrumbText States") {
    VStack(spacing: 12) {
        BreadcrumbText(words: ["I", "Want", "Play", "More"], highlightedCount: 0)
        BreadcrumbText(words: ["I", "Want", "Play", "More"], highlightedCount: 1)
        BreadcrumbText(words: ["I", "Want", "Play", "More"], highlightedCount: 2)
        BreadcrumbText(words: ["I", "Want", "Play", "More"], highlightedCount: 3)
        BreadcrumbText(words: ["I", "Want", "Play", "More"], highlightedCount: 4)
    }
    .padding()
    .background(Color.gray.opacity(0.15))
}
#endif

