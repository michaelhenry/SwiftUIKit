#if os(iOS)

import Foundation
import SwiftUI

@available(iOS 13.0, *)
struct PageControl: UIViewRepresentable {

    @Binding var numberOfPages: Int
    @Binding var currentPage: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(numberOfPages: $numberOfPages, currentPage: $currentPage)
    }

    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.pageIndicatorTintColor = UIColor.lightGray
        control.currentPageIndicatorTintColor = UIColor.darkGray
        control.addTarget(
            context.coordinator,
            action: #selector(Coordinator.updateCurrentPage(sender:)),
            for: .valueChanged)

        return control
    }

    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
        uiView.numberOfPages = numberOfPages
    }

    class Coordinator: NSObject {

        var numberOfPages:Binding<Int>
        var currentPage:Binding<Int>

        init(numberOfPages: Binding<Int>, currentPage:Binding<Int>) {
            self.numberOfPages = numberOfPages
            self.currentPage = currentPage
        }

        @objc
        func updateCurrentPage(sender: UIPageControl) {
            sender.currentPage = currentPage.wrappedValue
            sender.numberOfPages = numberOfPages.wrappedValue
        }
    }
}

#endif