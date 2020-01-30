
#if os(iOS)

import SwiftUI

@available(iOS 13.0, *)
@_functionBuilder
public struct PageBuilder<Page:View> {
    public static func buildBlock<Page:View>(_ pages: Page...) -> [Page] {
        pages
    }

    public static func buildBlock() -> EmptyView {
        return EmptyView()
    }

    public static func buildBlock<Page:View>(_ page:Page) -> Page {
        return page
    }
}

@available(iOS 13.0, *)
public struct PageView<Page:View>: View {

    private(set) var pageControlHidden:Bool = true

    @State private var viewControllers: [UIViewController] = []
    @State private var currentPage:Int = 0
    @State private var numberOfPages:Int = 0

    public init(
        pageControlHidden: Bool = true,
        views: [Page]
    ) {
        self.pageControlHidden = pageControlHidden
        _viewControllers = State(initialValue: views.map { UIHostingController(rootView: $0) })
        _numberOfPages = State(initialValue: views.count)
        _currentPage = State(initialValue: 0)
    }

    public init(pageControlHidden: Bool = true, @PageBuilder<Page> _ content: () -> [Page]) {
        self.init(pageControlHidden: pageControlHidden, views: content())
    }

    public init(pageControlHidden: Bool = true, @PageBuilder<Page> _ content: () -> Page) {
        self.init(pageControlHidden: pageControlHidden, views: [content()])
    }

    public var body: some View {
        ZStack(alignment: Alignment.bottom) {
            PageViewController(controllers: $viewControllers, currentPage: $currentPage)
            if pageControlHidden == false {
                PageControl(numberOfPages: $numberOfPages, currentPage: $currentPage)
            }
        }
    }
}

#endif