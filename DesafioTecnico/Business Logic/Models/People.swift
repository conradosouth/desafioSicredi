import Foundation

struct People: DataInit {
    
    var people: [Person]?
    
    init(data: [String : Any]) {
        
    }
    
    init(data: [[String: Any]]) {
      
        self.people = data.map { Person(data: $0) }
        
    }
}
