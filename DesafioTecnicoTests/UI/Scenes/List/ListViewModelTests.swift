import XCTest
@testable import DesafioTecnico

class ListViewModelTests: XCTestCase {
    
    private var service: MockEventAPI!
    var viewModel: ListViewModel!
    
    override func setUp() {
        continueAfterFailure = false
        
        service = MockEventAPI()
        viewModel = ListViewModel(service: service)
    }
    
    func testInit() {
        _ = ListViewModel()
        _ = ListViewModel(service: MockEventAPI())
    }
}
// MARK: - Features
extension ListViewModelTests {
    
    func testUpdateData() {
        
        viewModel.updateData(error: CustomError(message: "Error"), events: [Event(id: "1"), Event(id: "2")])
        XCTAssertNotNil(viewModel.data?.error)
        XCTAssertEqual(viewModel.data?.events?.count, 2)
    }
}

// MARK: - Services
extension ListViewModelTests {
    
    func testGetEventsError() {
        
        let testExpectation = expectation(description: "ListViewModelTest")
        
        viewModel.bind { sceneState in
            XCTAssertNotNil(sceneState?.error)
            testExpectation.fulfill()
        }
        
        service.shouldReturnError = true
        viewModel.readEvents()
        
        let waiterResult = XCTWaiter.wait(for: [testExpectation], timeout: 500)
        XCTAssertEqual(waiterResult, .completed)
    }
    
    func testGetEventsSuccess() {
        
        let testExpectation = expectation(description: "ListViewModelTest")
        
        viewModel.bind { sceneState in
            XCTAssertNil(sceneState?.error)
            XCTAssertEqual(sceneState?.events?.count, 3)
            testExpectation.fulfill()
        }
        
        service.shouldReturnError = false
        viewModel.readEvents()
        
        let waiterResult = XCTWaiter.wait(for: [testExpectation], timeout: 500)
        XCTAssertEqual(waiterResult, .completed)
    }
    
}
