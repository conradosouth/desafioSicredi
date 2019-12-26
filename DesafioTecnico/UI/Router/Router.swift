import UIKit

class Router {
	
	private func instantiateVC(for path: String) -> UIViewController? {
		let storyboard = UIStoryboard(name: path, bundle: nil)
		return storyboard.instantiateInitialViewController()
	}
}

// MARK: - RouterProtocol
extension Router: RouterProtocol {
	
	func destination<T: UIViewController>(for path: RouterPath) -> T? {
		let destinationVC = instantiateVC(for: path.rawValue)
		return destinationVC as? T
	}
}
