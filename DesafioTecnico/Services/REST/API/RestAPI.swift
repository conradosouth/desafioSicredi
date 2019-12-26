import Foundation

/// Base class for the API implementations
class RestAPI {
	
	/// Service to execute the requests
	let service: RestServiceProtocol
	
	/// Task of the current request
	var task: RestDataTaskProtocol?
	
	// MARK: - Initialization
	
	init(service: RestServiceProtocol? = nil) {
		self.service = service ?? URLSessionRestService()
	}
}

// MARK: - RestAPIProtocol
extension RestAPI: RestAPIProtocol {
	
	/// Cancels the current task
	func cancel() {
		task?.cancel()
		task = nil
	}
}
