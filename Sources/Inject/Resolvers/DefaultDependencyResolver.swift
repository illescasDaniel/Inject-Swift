//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 19/05/2020.
//

open class DefaultDependencyResolver: DependencyResolver {
	
	private var dependencies: [ObjectIdentifier: () -> Any] = [:]
	
	public init() {}
	
	open func add<T>(_ type: T.Type = T.self, using builder: @escaping () -> T) {
		dependencies[ObjectIdentifier(T.self)] = builder
	}

	open func resolve<T>() -> T {
		guard let value = dependencies[ObjectIdentifier(T.self)]?() as? T else {
			fatalError("You need to add \(T.self) to the dependency resolver")
		}
		return value
	}
	
	open func remove<T>(_ type: T.Type) {
		dependencies.removeValue(forKey: ObjectIdentifier(T.self))
	}
	
	open func removeAll() {
		self.dependencies.removeAll()
	}
	
	open func isAdded<T>(_ type: T.Type) -> Bool {
		return self.dependencies.keys.contains(ObjectIdentifier(T.self))
	}
}
