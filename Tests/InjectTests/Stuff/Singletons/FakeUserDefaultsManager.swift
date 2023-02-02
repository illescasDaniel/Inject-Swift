//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 19/05/2020.
//

protocol FakeUserDefaultsManager: AnyObject {
	var username: String { get }
}

protocol FakeUserDefaultsManager2 {
	var username: String { get set }
}

struct FakeUserDefaultsManagerStruct2: FakeUserDefaultsManager2 {

	var aValue: Int = 3

	init() {}

	var username: String = ""
	// ...
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
