import UIKit


final class AppCoordinator {
		let tabBarController: UITabBarController
		let window: UIWindow

		init(window: UIWindow) {
				self.window = window
				tabBarController = UITabBarController()
		}

		func start() {
				window.rootViewController = tabBarController
				window.makeKeyAndVisible()
				
				let mainVC: CurrentPlaceViewController = CurrentPlaceViewController()
				let mainNC: UINavigationController = UINavigationController(rootViewController: mainVC)
				let searchVC: SearchViewController = SearchViewController()
				let searchNC: UINavigationController = UINavigationController(rootViewController: searchVC)

				tabBarController.setViewControllers([mainNC, searchNC], animated: true)
				
				mainNC.tabBarItem = UITabBarItem(
						title: "Current Place",
						image: UIImage(systemName: "location"),
						selectedImage: UIImage(systemName: "location.fill")
				)
				searchNC.tabBarItem = UITabBarItem(
						title: "Other Place",
						image: UIImage(systemName: "globe.europe.africa"),
						selectedImage: UIImage(systemName: "globe.europe.africa.fill")
				)
		}
}
