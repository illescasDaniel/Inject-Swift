import XCTest
@testable import Inject

final class NestedDependenciesTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		
		// we always need some dependencies
		// we need to add these always, but in reality the resolution of the value is completely lazy
		// so it wouldn't crash if you don't add it unless you use it, but is good practice to always add all your dependencies
		
		DependencyInjection.dependencies.add(
			Database.self,
			using: DefaultDatabase() // autoclosure
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
