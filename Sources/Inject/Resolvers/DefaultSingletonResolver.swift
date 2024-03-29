//
//  File.swift
//
//
//  Created by Daniel Illescas Romero on 19/05/2020.
//

open class DefaultSingletonResolver: SingletonResolver {
	
	private var singletons: [ObjectIdentifier: Lazy<Any>] = [:]
	
	public init() {}
	
	open func add<T>(_ type: T.Type = T.self, using builder: @escaping () -> T) {
		singletons[ObjectIdentifier(T.self)] = .init(builder: builder)
	}
	
	open func addBox<T>(_ type: T.Type = T.self, using builder: @escaping () -> T) {
		singletons[ObjectIdentifier(Box<T>.self)] = .init(builder: { Box(builder()) })
	}
	
	open func resolve<T>() -> T {
		if let resolvedValue: Lazy<Any> = self.singletons[ObjectIdentifier(T.self)],
		   let wrappedValue = resolvedValue.wrappedValue as? T
		{
			return wrappedValue
		}
		fatalError("You need to add \(T.self) to the dependency resolver")
	}
	
	open func resolveBox<T>() -> Box<T> {
		if let resolvedValue: Lazy<Any> = self.singletons[ObjectIdentifier(Box<T>.self)],
		   let wrappedValue = resolvedValue.wrappedValue as? Box<T>
		{
			return wrappedValue
		}
		fatalError("You need to add \(T.self) to the dependency resolver")
	}
	
	open func remove<T>(_ type: T.Type) {
		singletons.removeValue(forKey: ObjectIdentifier(T.self))
	}
	
	open func removeAll() {
		self.singletons.removeAll()
	}
	
	open func isAdded<T>(_ type: T.Type) -> Bool {
		return self.singletons.keys.contains(ObjectIdentifier(T.self))
	}
	
	open func isAddedBox<T>(_ type: T.Type) -> Bool {
		return self.singletons.keys.contains(ObjectIdentifier(Box<T>.self))
	}
}
