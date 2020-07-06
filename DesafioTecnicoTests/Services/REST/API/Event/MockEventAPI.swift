@testable import DesafioTecnico
class MockEventAPI: EventAPIProtocol {
    
    var shouldReturnError = false
    
    var events: [Event] = [Event(id: "1", title: "Evento 1"),
                           Event(id: "2", title: "Evento 2"),
                           Event(id: "3", title: "Evento 3")]
    
    func getEvent(eventId: String, callback: @escaping (Error?, Event?) -> Void) {
        
        if shouldReturnError {
            callback(CustomError(message: "Error"), nil)
        } else {
            callback(nil, getEvent(withId: eventId))
        }
    }
    
    func getEvents(callback: @escaping (Error?, [Event]?) -> Void) {
        if shouldReturnError {
            callback(CustomError(message: "Error"), nil)
        } else {
            callback(nil, events)
        }
    }
    
    func postCheckin(eventId: String, callback: @escaping (Error?, SimpleResponse?) -> Void) {
        for event in events {
            if event.id == eventId {
                callback(nil, SimpleResponse(data: ["checkin": true]))
            }
        }
        callback(nil, nil)
    }
    
    func getEvent(withId id: String) -> Event? {
        return self.events.first(where: { $0.id == id })
    }
}
