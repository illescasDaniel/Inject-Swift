//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 19/05/2020.
//

protocol FakeUserDefaultsManager {
	var username: String { get }
}

struct FakeUserDefaultsManagerStruct {
	
	var aValue: Int = 3
	
	init() {}
	
	var username: String {
		get { "Daniel" }
		set { /*...*/ }
	}
	// ...
}

class FakeUserDefaultsManagerClass: FakeUserDefaultsManager {
	
	var aValue: Int = 3
	
	init() {}
	
	var username: String {
		get { "Daniel" }
		set { /*...*/ }
	}
	// ...
}

class FakeOtherUserDefaultsManager: FakeUserDefaultsManager {
	
	var aValue: Int = 3
	
	init() {}
	
	var username: String {
		get { "John" }
		set { /*...*/ }
	}
	// ...
}
