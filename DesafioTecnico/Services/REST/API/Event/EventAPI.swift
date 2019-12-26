import Foundation

class EventAPI: RestAPI, EventAPIProtocol {

    func getEvents(callback: @escaping (Error?, [Event]?) -> Void) {
        
        task = service.jsonTask(
            path: "/events",
            method: .get,
            parameters: nil,
            returnType: SimpleResponse.self) { [weak self] error, response in
                guard self != nil else { return }
                var events: [Event]?
                if let list = response?.data["list"] as? [[String: Any]] {
                    events = list.map { Event(data: $0) }
                }
                callback(error, events)
        }
    }
    
    func getEvent(eventId: String, callback: @escaping (Error?, Event?) -> Void) {
        
        task = service.jsonTask(
            path: "/events/\(eventId)",
            method: .get,
            parameters: nil,
            returnType: SimpleResponse.self) { [weak self] error, response in
                guard self != nil else { return }
                var event: Event?
                if let data = response?.data {
                    event = Event(data: data)
                }
                callback(error, event)
        }
    }
    
    func postCheckin(eventId: String, callback: @escaping (Error?) -> Void) {
        
        let parameters: [String: Any] = ["eventId": eventId,
                                         "name": "Conrado Werlang",
                                         "email": "werlang.conrado@gmail.com"]
        
        task = service.jsonTask(
            path: "/checkin",
            method: .post,
            parameters: parameters,
            returnType: SimpleResponse.self) { [weak self] error, response in
                guard self != nil else { return }
                print(response)
                callback(error)
        }
    }
}
