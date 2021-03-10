//
//  File.swift
//
//
//  Created by Daniel Illescas Romero on 19/05/2020.
//

@propertyWrapper
public struct AutoWiredBoxSingleton<T> {
	
	private let resolver: SingletonResolver
	
	public init(resolver: SingletonResolver) {
		assert(resolver.isAddedBox(T.self), "No dependency for: \(T.self)")
		self.resolver = resolver
	}
	
	public var wrappedValue: T {
		get { resolver.resolveBox(T.self).value }
		set {
			resolver.resolveBox(T.self).value = newValue
		}
	}
}

