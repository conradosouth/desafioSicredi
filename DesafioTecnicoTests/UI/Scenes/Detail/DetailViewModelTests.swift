import XCTest
@testable import DesafioTecnico

class DetailViewModelTests: XCTestCase {
    
    private var service: MockEventAPI!
    var viewModel: DetailViewModel!
    
    override func setUp() {
        continueAfterFailure = false
        
        service = MockEventAPI()
        viewModel = DetailViewModel(service: service)
    }
    
    func testInit() {
        _ = DetailViewModel()
        _ = DetailViewModel(service: MockEventAPI())
    }
}
// MARK: - Features
extension DetailViewModelTests {
    
    func testUpdateData() {
        
        viewModel.updateData(error: CustomError(message: "Error"), event: Event(id: "1"))
        XCTAssertNotNil(viewModel.data?.error)
        XCTAssertNotNil(viewModel.data?.event)
    }
}

// MARK: - Services
extension DetailViewModelTests {
    
    func testGetEventError() {
        
        let testExpectation = expectation(description: "DetailViewModelTest")
        
        viewModel.bind { sceneState in
            XCTAssertNotNil(sceneState?.error)
            testExpectation.fulfill()
        }
        
        service.shouldReturnError = true
        viewModel.readEvent(eventId: "1")
        
        let waiterResult = XCTWaiter.wait(for: [testExpectation], timeout: 500)
        XCTAssertEqual(waiterResult, .completed)
    }
    
    func testGetEventSuccess() {
        
        let testExpectation = expectation(description: "DetailViewModelTest")
        
        viewModel.bind { sceneState in
            XCTAssertNil(sceneState?.error)
            XCTAssertNotNil(sceneState?.event)
            testExpectation.fulfill()
        }
        
        service.shouldReturnError = false
        viewModel.readEvent(eventId: "1")
        
        let waiterResult = XCTWaiter.wait(for: [testExpectation], timeout: 500)
        XCTAssertEqual(waiterResult, .completed)
    }
    
    func testGetNonExistentEventFailure() {
        
        let testExpectation = expectation(description: "DetailViewModelTest")
        
        viewModel.bind { sceneState in
            XCTAssertNil(sceneState?.error)
            XCTAssertNil(sceneState?.event)
            testExpectation.fulfill()
        }
        
        service.shouldReturnError = false
        viewModel.readEvent(eventId: "8")
        
        let waiterResult = XCTWaiter.wait(for: [testExpectation], timeout: 500)
        XCTAssertEqual(waiterResult, .completed)
    }
}
