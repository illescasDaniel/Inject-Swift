//
//  File.swift
//
//
//  Created by Daniel Illescas Romero on 19/05/2020.
//

open class DefaultSingletonResolver: SingletonResolver {
	
	private var singletons: [ObjectIdentifier: Any] = [:] // TODO: use Box for structs
	
	public init() {}
	
	open func add<T: AnyObject>(_ builder: @escaping () -> T) {
		singletons[ObjectIdentifier(T.self)] = builder
	}
	
	open func add<V, T>(_ type: T.Type, using builder: @escaping () -> V) {
		if !(V.self is T.Type) { fatalError("\(V.self) is required to implement \(T.self).") }
		singletons[ObjectIdentifier(type)] = builder() // TODO: we should avoid this when possible, but I can't cast a function to () -> Any...
	}
	
	open func addBox<T>(_ builder: @escaping () -> T) {
		singletons[ObjectIdentifier(Box<T>.self)] = {
			return Box(builder())
		}
	}
	
	open func resolve<T>() -> T {
		
		if let valueBuilder = singletons[ObjectIdentifier(T.self)] as? (() -> T) {
			let resolvedValue = valueBuilder()
			singletons[ObjectIdentifier(T.self)] = resolvedValue
			return resolvedValue
		}
		
		if let value = singletons[ObjectIdentifier(T.self)] as? T {
			return value
		}
		
		fatalError("You need to add \(T.self) to the dependency resolver")
	}
	
	open func resolveBox<T>() -> Box<T> {
		
		if let valueBuilder = singletons[ObjectIdentifier(Box<T>.self)] as? (() -> Box<T>) {
			let resolvedValue = valueBuilder()
			singletons[ObjectIdentifier(Box<T>.self)] = resolvedValue
			return resolvedValue
		}
		
		if let value = singletons[ObjectIdentifier(Box<T>.self)] as? Box<T> {
			return value
		}
		
		fatalError("You need to add \(T.self) to the dependency resolver")
	}
	
	open func remove<T>(_ type: T.Type) {
		singletons.removeValue(forKey: ObjectIdentifier(type))
	}
	
	open func removeAll() {
		self.singletons.removeAll()
	}
	
	open func isAdded<T>(_ type: T.Type) -> Bool {
		return self.singletons.keys.contains(ObjectIdentifier(type))
	}
	
	open func isAddedBox<T>(_ type: T.Type) -> Bool {
		return self.singletons.keys.contains(ObjectIdentifier(Box<T>.self))
	}
}
