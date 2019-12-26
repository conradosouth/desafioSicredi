import Foundation

class DetailViewModel: ViewModel<DetailSceneState> {
    
    private var service: EventAPIProtocol
    
    init(service: EventAPIProtocol? = nil) {
        self.service = service ?? EventAPI()
        super.init()
        set(data: DetailSceneState())
    }
    
    required init() {
        service = EventAPI()
        super.init()
        set(data: DetailSceneState())
    }
    
    func readEvent(eventId: String) {
        DispatchQueue.global(qos: .background).async {
            self.service.getEvent(eventId: eventId) { [weak self] error, event in
                DispatchQueue.main.async {
                    guard let strongSelf = self else { return }
                    strongSelf.updateData(error: error, event: event)
                }
            }
        }
    }
    
    func checkin(eventId: String) {
        DispatchQueue.global(qos: .background).async {
            self.service.postCheckin(eventId: eventId) { [weak self] error in
                DispatchQueue.main.async {
                    guard let strongSelf = self else { return }
                    strongSelf.updateData(error: error, checkedIn: error != nil ? false : true)
                }
            }
        }
    }
    
    func updateData(error: Error?, event: Event? = nil, checkedIn: Bool? = nil) {
        update { sceneState in
            var sceneState = sceneState
            sceneState?.error = error
            sceneState?.checkedIn = checkedIn
            if let event = event {
                sceneState?.event = event
            }
            return sceneState
        }
    }
    
    func getEvent() -> Event? {
        return data?.event
    }
}
