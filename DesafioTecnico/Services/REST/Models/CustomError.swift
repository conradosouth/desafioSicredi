import Foundation

struct CustomError: Error, Equatable {
    
    let message: String
    
    init(message: String) {
        self.message = message
    }
}

// MARK: - LocalizedError
extension CustomError: LocalizedError {
    
    var errorMessage: String? {
        return message
    }
}
