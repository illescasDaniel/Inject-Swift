import XCTest
@testable import Inject

final class NestedDependenciesTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		
		DependencyInjection.dependencies.add(
			Database.self,
			using: DefaultDatabase()
		)
		
		DependencyInjection.dependencies.add(
			CarRepository.self,
			using: DefaultCarRepository(
				database: DependencyInjection.dependencies.resolve(Database.self)
			)
		)
	}
	
	func testNestedDependencies() {
		let nestedDependencies = NestedDependenciesExample(carRepository: nil /* injected */)
		XCTAssertEqual(nestedDependencies.fetchCar(id: 1).brand, "Toyot4")
	}

    static var allTests = [
        ("testNestedDependencies", testNestedDependencies),
    ]
}
