//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 19/05/2020.
//

@propertyWrapper
public struct AutoWired<T> {
	
	private let resolver: Resolver
	
	public init(resolver: Resolver) {
		assert(resolver.isAdded(T.self))
		self.resolver = resolver
	}
	
	public var wrappedValue: T {
		return resolver.resolve(T.self)
	}
}
