import Foundation

struct Coupon: DataInit {
    
    var id: String?
    
    var discount: Int?
    
    init(data: [String : Any]) {
        self.id = data["id"] as? String
        self.discount = data["discount"] as? Int
    }
    
}
