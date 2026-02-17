//
//  PDFScene.swift
//  SSC26
//
//  Created by Rodrigo Cont on 14/02/26.
//
import SwiftUI
import PDFKit

// Cache simples pra não recarregar PDF toda vez
@MainActor
final class PDFDocCache: ObservableObject {
    private var cache: [String: PDFDocument] = [:]

    func document(named name: String) -> PDFDocument? {
        if let d = cache[name] { return d }
        guard let url = Bundle.module.url(forResource: name, withExtension: "pdf"),
              let doc = PDFDocument(url: url) else {
            return nil
        }
        cache[name] = doc
        return doc
    }
}

struct PDFSinglePageView: UIViewRepresentable {
    let document: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let v = PDFView()
        v.displayMode = .singlePage
        v.displayDirection = .vertical
        v.displaysPageBreaks = false
        v.usePageViewController(false)
        v.backgroundColor = .clear
        v.isUserInteractionEnabled = false
        v.autoScales = false   // ✅ vamos controlar manualmente
        return v
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = document
        guard let page = document.page(at: 0) else { return }
        pdfView.go(to: page)

        // ✅ força preencher a tela (cover), mesmo que corte um pouco
        let pageRect = page.bounds(for: .cropBox)
        let viewSize = pdfView.bounds.size
        guard viewSize.width > 0, viewSize.height > 0 else { return }

        let scaleX = viewSize.width / pageRect.width
        let scaleY = viewSize.height / pageRect.height
        let scale = max(scaleX, scaleY) // cover

        pdfView.minScaleFactor = scale
        pdfView.maxScaleFactor = scale
        pdfView.scaleFactor = scale
    }
}

struct PDFScene: View {
    let pdfNameNoExt: String
    let onNext: () -> Void

    @StateObject private var cache = PDFDocCache()

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if let doc = cache.document(named: pdfNameNoExt) {
                PDFSinglePageView(document: doc)
                    .ignoresSafeArea()
            } else {
                // fallback caso o PDF não esteja no bundle
                Color.black.ignoresSafeArea()
                Text("Missing PDF: \(pdfNameNoExt).pdf")
                    .foregroundStyle(.white.opacity(0.8))
            }

            Button(action: onNext) { Image("NextButton") }
                .padding(28)
                .shadow(radius: 2, y: 4)
        }
        .ignoresSafeArea()
    }
}
