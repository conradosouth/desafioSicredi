import Foundation

struct Event: DataInit {
    
    var id: String?
    
    var title: String?
    var description: String?
    var image: String?
    
    var date: Int?
    var price: Double?
    var coupons: Coupons?
    var people: People?
    
    var latitude: Double?
    var longitude: Double?
    
    init(id: String? = nil,
         title: String? = nil) {
        self.id = id
        self.title = title
    }
    
    init(data: [String : Any]) {
        
        self.id = data["id"] as? String
        self.title = data["title"] as? String
        self.description = data["description"] as? String
        self.image = data["image"] as? String
        self.date = data["date"] as? Int
        self.price = data["price"] as? Double
        self.latitude = data["latitude"] as? Double
        self.longitude = data["longitude"] as? Double
        guard let dataCoupons = data["cupons"] as? [[String: Any]] else { return }
        self.coupons = Coupons(data: dataCoupons)
        guard let dataPeople = data["people"] as? [[String: Any]] else { return }
        self.people = People(data: dataPeople)        
        
    }
    
}
