import Foundation
import SwifterSwift

/// General data parser for the models
struct DataParser {
	
	/// Try to parse anything to Int
	///
	/// - Parameter data: Any data
	/// - Returns: Value if success
	static func parseInt(_ data: Any?) -> Int? {
		guard let data = data else { return nil }
		if let value = data as? Int {
			return value
		}
		if let value = data as? Float {
			return value.int
		}
		if let value = data as? Double {
			return value.int
		}
		if let value = data as? String, let double = DataParser.parseDouble(value) {
			return double.int
		}
		return nil
	}
	
	/// Try to parse anything to Double
	///
	/// - Parameter data: Any data
	/// - Returns: Value if success
	static func parseDouble(_ data: Any?) -> Double? {
		guard let data = data else { return nil }
		if let value = data as? Double {
			return value
		}
		if let value = data as? Int {
			return value.double
		}
		if let value = data as? Float {
			return value.double
		}
		if let value = data as? String {
			var result = value.double()
			if result == nil {
				result = Double(value)
			}
			return result
		}
		return nil
	}
	
	/// Try to parse anything to Bool
	///
	/// - Parameter data: Any data
	/// - Returns: Value if success
	static func parseBool(_ data: Any?) -> Bool? {
		guard let data = data else { return nil }
		if let value = data as? Bool {
			return value
		}
		if let value = data as? Int {
			return value == 1
		}
		if let value = data as? String {
			if let int = DataParser.parseInt(value) {
				return int == 0 ? false : int == 1 ? true : nil
			}
			switch value.uppercased() {
			case "S": return true
			case "Y": return true
			case "TRUE": return true
			case "N": return false
			case "FALSE": return false
			default: return nil
			}
		}
		return nil
	}
}
