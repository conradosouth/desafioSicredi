import Foundation

/// Connection between View and Model (UI/Business Logic)
class ViewModel<T> {
	
	/// Closure to be called when the data is set
	typealias Listener = (T?) -> Void
	
	/// Generic data. Must be specified by the subclasses
	private(set) var data: T? {
		didSet {
			listener?(data)
		}
	}
	
	/// Listener to be called when data is set
	var listener: Listener?
	
	/// When bind is called, the given closure will be stored in the ViewModel and will be called everytime the data is set
	///
	/// - Parameter listener: Closure to be called when data is set
	func bind(_ listener: @escaping Listener) {
		self.listener = listener
	}
	
	/// Replace the current value of the data property
	///
	/// - Parameter data: Value to be set
	func set(data: T?) {
		self.data = data
	}
	
	/// Check if a string is nil or empty and returns only if it has a value
	///
	/// - Parameter value: String to be tested
	/// - Returns: String or nil
	func nvl(string value: String?) -> String? {
		if let value = value, !value.isEmpty {
			return value
		}
		return nil
	}
	
	// MARK: - Initialization
	
	required init() {}
}

// MARK: - Value Types
extension ViewModel where T: Any {
	
	/// Updates data with a closure for value types
	///
	/// - Parameter block: Closure with the current data value
	func update(block: (T?) -> T?) {
		data = block(data)
	}
}
