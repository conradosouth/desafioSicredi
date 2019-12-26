import Foundation

/// Protocol to implement the REST Service
protocol RestServiceProtocol {
	
	@discardableResult
	func jsonTask<T: DataInit>(path: String,
							   method: RestMethod,
							   parameters: [String: Any]?,
							   returnType: T.Type,
							   callback: @escaping (Error?, T?) -> Void) -> RestDataTaskProtocol?
    
}
