import Foundation

struct Person: DataInit {
    
    var id: String?
    
    var name: String?
    var picture: String?
    
    init(data: [String : Any]) {
        
        self.id = data["id"] as? String
        self.name = data["name"] as? String
        self.picture = data["picture"] as? String
        
    }
}
