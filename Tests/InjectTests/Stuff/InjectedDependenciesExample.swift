//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 19/05/2020.
//

import Inject

struct InjectedDependenciesExample {
	
	@Inject()
	private var userRepository: UserRepository
	
	@AutoWired()
	var imagesRepository: ImagesRepository
	
	@AutoWired()
	private var wiredUserRepository: UserRepository
	
	@InjectSingleton()
	var userDefaults0: FakeUserDefaultsManager
	
	@AutoWiredSingleton()
	var userDefaults: FakeUserDefaultsManagerClass
	
	@AutoWiredSingleton()
	var userDefaultsStruct: Box<FakeUserDefaultsManagerStruct>
	
	@AutoWiredBoxSingleton()
	var userDefaultsStruct2: FakeUserDefaultsManagerStruct
	
	init() {}
	
	init(
		userRepository: UserRepository?,
		userDefaults: FakeUserDefaultsManager?
	) {
		self.$userRepository = userRepository
		self.$userDefaults0 = userDefaults
	}
	
	func add(user: String) -> Int {
		return self.userRepository.add(user: user)
	}
	
	func autoWired_add(user: String) -> Int {
		return self.wiredUserRepository.add(user: user)
	}
	
	func username() -> String {
		return userDefaults.username
	}
}
