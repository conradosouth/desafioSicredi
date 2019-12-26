import Foundation

/// Implementation of the RestServiceProtocol using URLSession
class URLSessionRestService {
	
	/// URLSession to be used on the request
	private let session: URLSession
	
	// MARK: - Initialization
	
	init(session: URLSession? = nil) {
		
		self.session = session ?? URLSession.shared
        
	}
}

// MARK: - Request Creation
extension URLSessionRestService {
	
	/// Converts a Codable Object into a Dictionary
	///
	/// - Parameter object: Codable object
	/// - Returns: Dictionary or nil
	private func dict<T: Codable>(with object: T?) -> [String: Any]? {
		let encoder = JSONEncoder()
		if let object = object, let encoded = try? encoder.encode(object) {
			return try? JSONSerialization.jsonObject(with: encoded, options: .mutableContainers) as? [String: Any]
		}
		return nil
	}
	
	/// Creates the URL
	///
	/// - Parameters:
	///   - path: Path of the API
	///   - query: Query for GET requests
	/// - Returns: URL with components
	private func makeUrlComponents(path: String, query: [String: Any]? = nil) -> URLComponents {
		
		var urlComponents = URLComponents()
		urlComponents.scheme = "http"
		urlComponents.host = "5b840ba5db24a100142dcd8c.mockapi.io"
		urlComponents.path = "/api" + path
		if let query = query, query.count > 0 {
			urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
		}
		return urlComponents
	}
	
	/// Creates a request object
	///
	/// - Parameters:
	///   - path: Path of the request
	///   - method: Method of the request
	///   - parameters: Query for GET and Body for the rest
	///   - needSecurity: Flag to add security
	/// - Returns: Request or nil
	private func makeRequest(path: String,
							 method: RestMethod,
							 parameters: [String: Any]?) -> URLRequest? {
		var query: [String: Any]?
		var jsonBody: [String: Any]?
		if method == .get {
			query = parameters
		} else {
			jsonBody = parameters
		}
		let completePath = path
		let urlComponents = makeUrlComponents(path: completePath, query: query)
		guard let url = urlComponents.url else { return nil }
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		if let body = jsonBody {
			request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
		}
		return request
	}
}

// MARK: - Request Execution
extension URLSessionRestService {
	
	/// Process the response from the server
	///
	/// - Parameters:
	///   - error: Error from the response
	///   - data: Data from the response
	///   - returnType: Desired return type
	///   - callback: Completion closure
	private func processResponse<T: DataInit>(error: Error?,
											  data: Data?,
											  returnType: T.Type,
											  callback: @escaping (Error?, T?) -> Void) {
		
		if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
		
            callback(error, T(data: json))
			
		} else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] {
			callback(error, T(data: ["list": json]))
		} else {
			callback(error, nil)
		}
	}
	
	/// Creates a data task and returns the given type
	///
	/// - Parameters:
	///   - request: Request to be executed
	///   - returnType: Desired return type
	///   - callback: Completion closure
	/// - Returns: Data task
	private func dataTask<T: DataInit>(request: URLRequest,
									   returnType: T.Type,
									   callback: @escaping (Error?, T?) -> Void) -> RestDataTaskProtocol {
		
		let task = session.dataTask(with: request) { [weak self] data, _, error in
			guard let strongSelf = self else { return }
			strongSelf.processResponse(error: error, data: data, returnType: returnType, callback: callback)
		}
		task.resume()
		return task
	}
	
	/// Creates an upload task and returns the given type
	///
	/// - Parameters:
	///   - request: Request to be executed
	///   - returnType: Desired return type
	///   - callback: Completion closure
	/// - Returns: Data task
//	private func uploadTask<T: DataInit>(request: URLRequest,
//										 data: Data,
//										 returnType: T.Type,
//										 callback: @escaping (Error?, T?) -> Void) -> RestDataTaskProtocol {
//
//		let task = session.uploadTask(with: request, from: data) { [weak self] data, _, error in
//			guard let strongSelf = self else { return }
//			strongSelf.processResponse(error: error, data: data, returnType: returnType, callback: callback)
//		}
//		task.resume()
//		return task
//	}
}

// MARK: - RestServiceProtocol
extension URLSessionRestService: RestServiceProtocol {
	
	@discardableResult
	func jsonTask<T: DataInit>(path: String,
							   method: RestMethod,
							   parameters: [String: Any]?,
							   returnType: T.Type,
							   callback: @escaping (Error?, T?) -> Void) -> RestDataTaskProtocol? {
		
		guard let request = makeRequest(path: path,
										method: method,
										parameters: parameters)
			else {
				return nil
		}
		return dataTask(request: request, returnType: returnType, callback: callback)
	}
}
