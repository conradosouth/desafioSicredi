import Foundation

class ListViewModel: ViewModel<ListSceneState> {
    
    private var service: EventAPIProtocol
    
    init(service: EventAPIProtocol? = nil) {
        self.service = service ?? EventAPI()
        super.init()
        set(data: ListSceneState())
    }
    
    required init() {
        service = EventAPI()
        super.init()
        set(data: ListSceneState())
    }
    
    func readEvents() {
        DispatchQueue.global(qos: .background).async {
            self.service.getEvents { [weak self] error, events in
                DispatchQueue.main.async {
                    guard let strongSelf = self else { return }
                    strongSelf.updateData(error: error, events: events)
                }
            }
        }
    }
    
    func updateData(error: Error?, events: [Event]?) {
        update { sceneState in
            var sceneState = sceneState
            sceneState?.error = error
            sceneState?.events = events ?? []
            return sceneState
        }
    }
    
    func getEvent(index: Int) -> Event? {
        guard let events = data?.events else { return nil }
        return events[index]
    }
    
}
