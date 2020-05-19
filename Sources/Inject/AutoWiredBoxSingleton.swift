//
//  File.swift
//
//
//  Created by Daniel Illescas Romero on 19/05/2020.
//

@propertyWrapper
public struct AutoWiredBoxSingleton<T> {
	
	@Lazy
	private var boxValue: Box<T>
	
	public init(resolver: SingletonResolver) {
		assert(resolver.isAddedBox(T.self))
		self.$boxValue = { resolver.resolveBox(T.self) }
	}
	
	public var wrappedValue: T {
		get { boxValue.value }
		set {
			boxValue.value = newValue
		}
	}
}

