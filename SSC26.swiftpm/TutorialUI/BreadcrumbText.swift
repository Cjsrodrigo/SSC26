import SwiftUI

struct BreadcrumbText: View {
    let words: [String]
    let highlightedCount: Int
    var flashError: Bool = false   // ✅ novo

    var body: some View {
        words.enumerated().reduce(Text("")) { acc, item in
            let idx = item.offset
            let isDone = idx < highlightedCount

            let wordColor: Color = flashError ? .red : (isDone ? .blue : .black)
            let sepColor: Color  = flashError ? .red : ((idx < (highlightedCount - 1)) ? .blue : Color.black.opacity(0.85))

            let word = Text(item.element).foregroundColor(wordColor)

            let sep: Text = (idx == words.count - 1)
            ? Text("")
            : Text("  >  ").foregroundColor(sepColor)

            return acc + word + sep
        }
        .font(.system(size: 12, weight: .bold))
    }
}
