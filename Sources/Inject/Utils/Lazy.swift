//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 19/05/2020.
//

@propertyWrapper
internal class Lazy<T> {
	
	private var value: T!
	private var builder: (() -> T)!
	
	init(_ builder: @autoclosure @escaping () -> T) {
		self.builder = builder
	}
	
	init(_ builder: @escaping () -> T) {
		self.builder = builder
	}
	
	init() {
		
	}
	
	public var wrappedValue: T {
		get {
			if let validValue = self.value {
				return validValue
			} else {
				if let valueBuilder = self.builder {
					self.value = valueBuilder()
					return self.value
				} else {
					fatalError("Missing value builder for Lazy<\(T.self)>")
				}
			}
		}
		set { value = newValue }
	}
	
	public var projectedValue: (() -> T)? {
		get { builder }
		set {
			if let newBuilder = newValue {
				self.builder = newBuilder
			}
		}
	}
}
