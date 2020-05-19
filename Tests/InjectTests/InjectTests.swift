import XCTest
@testable import Inject

final class InjectTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		
		// we always need some dependencies
		// we need to add these always, but in reality the resolution of the value is completely lazy
		// so it wouldn't crash if you don't add it unless you use it, but is good practice to always add all your dependencies
		
		DependencyInjection.dependencies.add(
			UserRepository.self,
			using: DefaultUserRepository() // autoclosure
		)
		DependencyInjection.singletons.addBox(FakeUserDefaultsManagerStruct())
		DependencyInjection.singletons.add(FakeUserDefaultsManagerClass())
	}
	
    func testRegisterDependency() {
		DependencyInjection.dependencies.add(
			UserRepository.self,
			using: DefaultUserRepository() // autoclosure
		)
		
		let userRepository: UserRepository = DependencyInjection.dependencies.resolve()
		XCTAssertEqual(userRepository.add(user: "a"), 1)
    }
	
	func testRegisterDependency2() {
		DependencyInjection.dependencies.add(
			UserRepository.self,
			using: OtherUserRepository()
		)
		
		let userRepository2: UserRepository = DependencyInjection.dependencies.resolve()
		XCTAssertEqual(userRepository2.add(user: "a"), 0)
	}
	
	func testUseInjectedDependencies1() {
		DependencyInjection.dependencies.add(
			UserRepository.self,
			using: DefaultUserRepository()
		)
		// picks up the injected value if any
		let something = InjectedDependenciesExample(userRepository: nil, userDefaults: nil)
		XCTAssertEqual(something.add(user: "a"), 1)
	}
	
	func testUseInjectedDependencies2() {
		DependencyInjection.dependencies.add(
			UserRepository.self,
			using: OtherUserRepository()
		)
		
		let something = InjectedDependenciesExample(userRepository: nil, userDefaults: nil)
		XCTAssertEqual(something.add(user: "a"), 0)
	}
	
	func testUseInjectedDependencies3() {
		DependencyInjection.dependencies.add(
			UserRepository.self,
			using: StructUserRepository()
		)
		
		let something = InjectedDependenciesExample(userRepository: nil, userDefaults: nil)
		XCTAssertEqual(something.add(user: "b"), 2)
		
		let something2 = InjectedDependenciesExample(userRepository: nil, userDefaults: nil)
		XCTAssertEqual(something2.add(user: "b"), 2)
	}
	
	func testUseInjectedDependencies4() {
				
		DependencyInjection.singletons.add(
			FakeUserDefaultsManager.self,
			using: FakeOtherUserDefaultsManager()
		)
		
		let something = InjectedDependenciesExample(userRepository: nil, userDefaults: nil)
		XCTAssertEqual(something.userDefaults0.username, "John")
		
		DependencyInjection.singletons.add(
			FakeUserDefaultsManager.self,
			using: FakeUserDefaultsManagerClass()
		)
		
		let something2 = InjectedDependenciesExample(userRepository: nil, userDefaults: nil)
		XCTAssertEqual(something2.userDefaults0.username, "Daniel")
	}
	
	func testInjectDependencies1() {
		DependencyInjection.dependencies.add(
			UserRepository.self,
			using: DefaultUserRepository()
		)
		// overrides injected value
		let something = InjectedDependenciesExample(userRepository: OtherUserRepository(), userDefaults: nil)
		XCTAssertEqual(something.add(user: "a"), 0)
	}
	
	func testInjectDependencies2() {
		DependencyInjection.dependencies.add(
			UserRepository.self,
			using: OtherUserRepository()
		)
		// overrides injected value
		let something = InjectedDependenciesExample(userRepository: DefaultUserRepository(), userDefaults: nil)
		XCTAssertEqual(something.add(user: "a"), 1)
	}
	
	func testInjectDependencies3() {
		DependencyInjection.singletons.add(
			FakeUserDefaultsManager.self,
			using: FakeOtherUserDefaultsManager()
		)
		// overrides injected value
		let something = InjectedDependenciesExample(userRepository: nil, userDefaults: FakeUserDefaultsManagerClass())
		XCTAssertEqual(something.username(), "Daniel")
	}
	
	func testAutoWiredDependencies() {
		DependencyInjection.dependencies.add(
			UserRepository.self,
			using: OtherUserRepository()
		)
		
		let something = InjectedDependenciesExample()
		XCTAssertEqual(something.autoWired_add(user: "a"), 0)
	}
	
	func testAutoWiredDependenciesSingleton() {
		DependencyInjection.singletons.add(FakeUserDefaultsManagerClass())
		
		let something = InjectedDependenciesExample()
		XCTAssertEqual(something.username(), "Daniel")
	}
	
	func testSingleton() {
		DependencyInjection.singletons.add(FakeUserDefaultsManagerClass())
		
		let fakeUserDefaults = DependencyInjection.singletons.resolve(FakeUserDefaultsManagerClass.self)
		XCTAssertEqual(fakeUserDefaults.username, "Daniel")
		
		let fakeUserDefaults2: FakeUserDefaultsManagerClass = DependencyInjection.singletons.resolve()
		XCTAssertEqual(fakeUserDefaults2.username, "Daniel")
	}
	
	func testSingletonReferenceValue1() {
		DependencyInjection.singletons.add(FakeUserDefaultsManagerClass())

		let something = InjectedDependenciesExample()
		something.userDefaults.aValue = 10

		let something2 = InjectedDependenciesExample()
		XCTAssertEqual(something2.userDefaults.aValue, 10)
	}
	
	func testSingletonReferenceValue2() {
		DependencyInjection.singletons.add(Box(FakeUserDefaultsManagerStruct()))

		let something = InjectedDependenciesExample()
		something.userDefaultsStruct.value.aValue = 12

		let something2 = InjectedDependenciesExample()
		XCTAssertEqual(something2.userDefaultsStruct.value.aValue, 12)
		
		something2.userDefaultsStruct.value.aValue = 20
		XCTAssertEqual(something.userDefaultsStruct.value.aValue, 20)
	}
	
	func testSingletonReferenceValue3() {
		DependencyInjection.singletons.addBox(FakeUserDefaultsManagerStruct())

		var something = InjectedDependenciesExample()
		something.userDefaultsStruct2.aValue = 12

		var something2 = InjectedDependenciesExample()
		XCTAssertEqual(something2.userDefaultsStruct2.aValue, 12)
		
		something2.userDefaultsStruct2.aValue = 20
		XCTAssertEqual(something.userDefaultsStruct2.aValue, 20)
	}

    static var allTests = [
        ("testRegisterDependency", testRegisterDependency),
		("testRegisterDependency2", testRegisterDependency2),
		("testUseInjectedDependencies1", testUseInjectedDependencies1),
		("testUseInjectedDependencies2", testUseInjectedDependencies2),
		("testUseInjectedDependencies3", testUseInjectedDependencies3),
		("testUseInjectedDependencies4", testUseInjectedDependencies4),
		("testInjectDependencies1", testInjectDependencies1),
		("testInjectDependencies2", testInjectDependencies2),
		("testInjectDependencies3", testInjectDependencies3),
		("testAutoWiredDependencies", testAutoWiredDependencies),
		("testAutoWiredDependenciesSingleton", testAutoWiredDependenciesSingleton),
		("testSingleton", testSingleton),
		("testSingletonReferenceValue1", testSingletonReferenceValue1),
		("testSingletonReferenceValue2", testSingletonReferenceValue2),
		("testSingletonReferenceValue3", testSingletonReferenceValue3)
    ]
}
