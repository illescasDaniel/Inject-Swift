//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 19/05/2020.
//

@propertyWrapper
public struct AutoWiredSingleton<T> {
	
	@Lazy
	private var value: T
	
	public init(resolver: SingletonResolver) {
		assert(resolver.isAdded(T.self))
		self.$value = { resolver.resolve(T.self) }
	}
	
	public var wrappedValue: T {
		return value
	}
}

