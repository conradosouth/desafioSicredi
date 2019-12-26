import Foundation

/// Protocol to create instances with a dictionary containing all necessadry data. Used on the return of the services
protocol DataInit {
	
	/// Initialization with a dictionary
	///
	/// - Parameter data: Dictionary with all data using String keys
	init(data: [String: Any])
}
