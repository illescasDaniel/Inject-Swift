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
		
		DependencyInjection.dependencies.add(ImagesRepository())
		
		DependencyInjection.singletons.add(
			FakeUserDefaultsManager.self,
			using: FakeOtherUserDefaultsManager()
		)
		DependencyInjection.singletons.addBox(FakeUserDefaultsManagerStruct())
		DependencyInjection.singletons.add(FakeUserDefaultsManagerClass())
	}
	
	func testRegisterDependency() {
		DependencyInjection.dependencies.add(
			UserRepository.self,
			using: DefaultUserRepository() // autoclosure
		)
		XCTAssertTrue(DependencyInjection.dependencies.isAdded(UserRepository.self))
		
		let userRepository: UserRepository = DependencyInjection.dependencies.resolve()
		XCTAssertEqual(userRepository.add(user: "a"), 1)
	}
	
	func testRegisterDependency2() {
		DependencyInjection.dependencies.add(
			UserRepository.self,
			using: OtherUserRepository()
		)
		XCTAssertTrue(DependencyInjection.dependencies.isAdded(UserRepository.self))
		
		let userRepository2: UserRepository = DependencyInjection.dependencies.resolve()
		XCTAssertEqual(userRepository2.add(user: "a"), 0)
	}
	
	func testUseInjectedDependencies1() {
		DependencyInjection.dependencies.add(
			UserRepository.self,
			using: DefaultUserRepository()
		)
		XCTAssertTrue(DependencyInjection.dependencies.isAdded(UserRepository.self))
		
		// picks up the injected value if any
		let something = InjectedDependenciesExample(userRepository: nil, userDefaults: nil)
		XCTAssertEqual(something.add(user: "a"), 1)
	}
	
	func testUseInjectedDependencies2() {
		DependencyInjection.dependencies.add(
			UserRepository.self,
			using: OtherUserRepository()
		)
		XCTAssertTrue(DependencyInjection.dependencies.isAdded(UserRepository.self))
		
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
		XCTAssertTrue(DependencyInjection.singletons.isAdded(FakeUserDefaultsManager.self))
		
		let something = InjectedDependenciesExample(userRepository: nil, userDefaults: nil)
		XCTAssertEqual(something.userDefaults0.username, "John")
		
		// this replaces the previous dependency value
		DependencyInjection.singletons.add(
			FakeUserDefaultsManager.self,
			using: FakeUserDefaultsManagerClass()
		)
		XCTAssertTrue(DependencyInjection.singletons.isAdded(FakeUserDefaultsManager.self))
		
		let something2 = InjectedDependenciesExample(userRepository: nil, userDefaults: nil)
		XCTAssertEqual(something2.userDefaults0.username, "Daniel")
	}
	
	func testUseInjectedDependencies5() {
		
		DependencyInjection.dependencies.add(ImagesRepository())
		XCTAssertTrue(DependencyInjection.dependencies.isAdded(ImagesRepository.self))
		
		let something = InjectedDependenciesExample(userRepository: nil, userDefaults: nil)
		XCTAssertEqual(something.imagesRepository.getImage(id: ""), [1,2,3])
	}
	
	func testInjectDependencies1() {
		DependencyInjection.dependencies.add(
			UserRepository.self,
			using: DefaultUserRepository()
		)
		XCTAssertTrue(DependencyInjection.dependencies.isAdded(UserRepository.self))
		
		// overrides injected value
		let something = InjectedDependenciesExample(userRepository: OtherUserRepository(), userDefaults: nil)
		XCTAssertEqual(something.add(user: "a"), 0)
	}
	
	func testInjectDependencies2() {
		DependencyInjection.dependencies.add(
			UserRepository.self,
			using: OtherUserRepository()
		)
		XCTAssertTrue(DependencyInjection.dependencies.isAdded(UserRepository.self))
		
		// overrides injected value
		let something = InjectedDependenciesExample(userRepository: DefaultUserRepository(), userDefaults: nil)
		XCTAssertEqual(something.add(user: "a"), 1)
	}
	
	func testInjectDependencies3() {
		DependencyInjection.singletons.add(
			FakeUserDefaultsManager.self,
			using: FakeOtherUserDefaultsManager()
		)
		XCTAssertTrue(DependencyInjection.singletons.isAdded(FakeUserDefaultsManager.self))
		
		// overrides injected value
		let something = InjectedDependenciesExample(userRepository: nil, userDefaults: FakeUserDefaultsManagerClass())
		XCTAssertEqual(something.username(), "Daniel")
	}
	
	func testAutoWiredDependencies() {
		DependencyInjection.dependencies.add(
			UserRepository.self,
			using: OtherUserRepository()
		)
		XCTAssertTrue(DependencyInjection.dependencies.isAdded(UserRepository.self))
		
		let something = InjectedDependenciesExample()
		XCTAssertEqual(something.autoWired_add(user: "a"), 0)
	}
	
	func testAutoWiredDependenciesSingleton() {
		DependencyInjection.singletons.add(FakeUserDefaultsManagerClass())
		XCTAssertTrue(DependencyInjection.singletons.isAdded(FakeUserDefaultsManagerClass.self))
		
		let something = InjectedDependenciesExample()
		XCTAssertEqual(something.username(), "Daniel")
	}
	
	func testSingleton() {
		DependencyInjection.singletons.add(FakeUserDefaultsManagerClass())
		XCTAssertTrue(DependencyInjection.singletons.isAdded(FakeUserDefaultsManagerClass.self))
		
		let fakeUserDefaults = DependencyInjection.singletons.resolve(FakeUserDefaultsManagerClass.self)
		XCTAssertEqual(fakeUserDefaults.username, "Daniel")
		
		let fakeUserDefaults2: FakeUserDefaultsManagerClass = DependencyInjection.singletons.resolve()
		XCTAssertEqual(fakeUserDefaults2.username, "Daniel")
	}
	
	func testSingletonReferenceValue1() {
		DependencyInjection.singletons.add(FakeUserDefaultsManagerClass())
		XCTAssertTrue(DependencyInjection.singletons.isAdded(FakeUserDefaultsManagerClass.self))
		
		let something = InjectedDependenciesExample()
		something.userDefaults.aValue = 10
		
		let something2 = InjectedDependenciesExample()
		XCTAssertEqual(something2.userDefaults.aValue, 10)
	}
	
	func testSingletonReferenceValue2() {
		DependencyInjection.singletons.add(Box(FakeUserDefaultsManagerStruct()))
		XCTAssertTrue(DependencyInjection.singletons.isAdded(Box<FakeUserDefaultsManagerStruct>.self))
		
		let something = InjectedDependenciesExample()
		something.userDefaultsStruct.value.aValue = 12
		
		let something2 = InjectedDependenciesExample()
		XCTAssertEqual(something2.userDefaultsStruct.value.aValue, 12)
		
		something2.userDefaultsStruct.value.aValue = 20
		XCTAssertEqual(something.userDefaultsStruct.value.aValue, 20)
	}
	
	func testSingletonReferenceValue3() {
		DependencyInjection.singletons.addBox(FakeUserDefaultsManagerStruct())
		XCTAssertTrue(DependencyInjection.singletons.isAdded(Box<FakeUserDefaultsManagerStruct>.self))
		
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
		("testUseInjectedDependencies5", testUseInjectedDependencies5),
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
