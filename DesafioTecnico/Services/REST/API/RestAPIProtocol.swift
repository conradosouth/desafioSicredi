import Foundation

/// Protocol to implement the APIs from the REST Service
protocol RestAPIProtocol {
	
	/// Service to execute the requests
	var service: RestServiceProtocol { get }
	
	/// Task of the current request
	var task: RestDataTaskProtocol? { get set }
	
	/// Cancels the current task
	func cancel()
}
