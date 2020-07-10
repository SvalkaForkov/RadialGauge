import UIKit

class AppCoordinator {

	private var window: UIWindow!
	let navigationController = UINavigationController()

	init(window: UIWindow) {
		presentInWindow(window: window)
	}

	func start() {
		navigationController.isNavigationBarHidden = true
		presentHomeScreen()
	}

	private func presentHomeScreen() {
		let homePresenter = HomePresenter()
		let launchViewController = HomeViewController(homePresenter: homePresenter)
		navigationController.pushViewController(launchViewController, animated: false)
	}

	private func presentInWindow(window: UIWindow) {
		self.window = window
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
	}

}
