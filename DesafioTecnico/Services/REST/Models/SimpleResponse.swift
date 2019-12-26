import Foundation

/// General model from service responses
struct SimpleResponse: DataInit {
	
	/// Dictionary with all data using String keys
	var data: [String: Any]
	
	// MARK: - Initialization
	
	init(data: [String: Any]) {
		self.data = data
	}
}
