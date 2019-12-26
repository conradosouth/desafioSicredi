import Foundation

struct Coupons: DataInit {
    
    var coupons: [Coupon]?
    
    init(data: [String : Any]) {
        
    }
    
    init(data: [[String: Any]]) {
      
        self.coupons = data.map { Coupon(data: $0) }
        
    }
}
