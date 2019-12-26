import UIKit

/// Protocol to implement a navigation router
protocol RouterProtocol {
	
	/// Creates a view controller for the given path
	///
	/// - Parameters:
	///   - path: Path to go
	/// - Returns: Destination view controller
	func destination<T: UIViewController>(for path: RouterPath) -> T?
}
