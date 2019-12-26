import UIKit

/// Loader Scene
class LoaderViewController: UIViewController {
	
	// MARK: - IBOutlets
	
	@IBOutlet private weak var loaderActivityIndicator: UIActivityIndicatorView!
	
	// MARK: - User Interface
	
	func startLoader() {
		loaderActivityIndicator.startAnimating()
	}
	
	func stopLoader() {
		loaderActivityIndicator.stopAnimating()
	}
}
