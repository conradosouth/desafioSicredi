import UIKit

protocol SceneDelegate: class {
	func newDataAvailable(data: Any)
}

class BaseViewController<SS, VM: ViewModel<SS>>: UIViewController {
	
	var router: RouterProtocol?
	
	var viewModel: VM!
	
	weak var delegate: SceneDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
		viewModel = VM()
		viewModel?.bind { [weak self] sceneState in
			self?.updateUI(sceneState: sceneState)
		}
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	/// Shows the Loader scene on top of the current scene
	func showLoader() {
		let appDelegate = UIApplication.shared.delegate as? AppDelegate
		appDelegate?.showLoader()
	}
	
	/// Hides the Loader scene
	func hideLoader() {
		let appDelegate = UIApplication.shared.delegate as? AppDelegate
		appDelegate?.hideLoader()
	}
	
	/// Displays an Error alert
	///
	/// - Parameter message: Message of the error alert
	func showErrorAlert(message: String) {
		let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		present(alert, animated: true, completion: nil)
	}
	
	/// Go back in the navigation
	///
	/// - Parameter animated: Should animate or not
	func goBack(animated: Bool = false) {
		if let nav = navigationController {
			nav.popViewController(animated: animated)
		} else {
			dismiss(animated: animated, completion: nil)
		}
	}
	
	/// Makes the initial setup
	private func setup() {
		router = router ?? Router()
		
	}
	
	/// Use this method to instantiate and bind the ViewModel
	open func updateUI(sceneState: SS?) {}
}
