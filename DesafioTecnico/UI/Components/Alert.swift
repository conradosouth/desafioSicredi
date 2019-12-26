import UIKit

class Alert {
	
	func showSimpleAlert(vc: UIViewController, title: String?, text: String) {
		
		let alert = UIAlertController.init(title: title ?? "Erro", message: text, preferredStyle: .alert)
		let ok = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
		
		alert.addAction(ok)
		
		vc.present(alert, animated: true, completion: nil)
	}
}
