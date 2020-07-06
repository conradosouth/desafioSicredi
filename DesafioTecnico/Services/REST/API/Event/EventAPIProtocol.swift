import Foundation

protocol EventAPIProtocol {

    func getEvents(callback: @escaping (Error?, [Event]?) -> Void)
    
    func getEvent(eventId: String, callback: @escaping (Error?, Event?) -> Void)
    
    func postCheckin(eventId: String, callback: @escaping (Error?, SimpleResponse?) -> Void)
}
