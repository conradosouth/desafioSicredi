import Foundation

/// Data task of the HTTP service
protocol RestDataTaskProtocol {
	
	/// Temporarily suspends a task
	func suspend()
	
	/// Resumes the task, if it is suspended
	func resume()
	
	/// Cancels the task
	func cancel()
}

// MARK: - Apply Extensions
extension URLSessionDataTask: RestDataTaskProtocol {}
