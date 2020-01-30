
#if os(iOS)

import UIKit
import SwiftUI

@available(iOS 13.0, *)
struct PageViewController: UIViewControllerRepresentable {

    @Binding var controllers: [UIViewController]
    @Binding var currentPage: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(controllers: $controllers, currentPage: $currentPage)
    }

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        return pageViewController
    }

    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        guard controllers.count > 0 && currentPage < controllers.count else { return }
        pageViewController.setViewControllers(
            [controllers[currentPage]], direction: .forward, animated: true)
    }

    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

        var controllers: Binding<[UIViewController]>
        var currentPage: Binding<Int>

        init(controllers: Binding<[UIViewController]>, currentPage: Binding<Int>) {
            self.controllers = controllers
            self.currentPage = currentPage
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController) -> UIViewController? {

            guard let index = controllers.wrappedValue.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                return nil
            }

            return controllers.wrappedValue[index - 1]
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController) -> UIViewController? {

            guard let index = controllers.wrappedValue.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == controllers.wrappedValue.count {
                return nil
            }
            return controllers.wrappedValue[index + 1]
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            didFinishAnimating finished: Bool,
            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

            if completed,
                let visibleViewController = pageViewController.viewControllers?.first,
                let index = controllers.wrappedValue.firstIndex(of: visibleViewController) {
                self.currentPage.wrappedValue = index
            }
        }
    }
}

#endif