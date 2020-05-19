//
//  File.swift
//
//
//  Created by Daniel Illescas Romero on 19/05/2020.
//

public protocol SingletonResolver: Resolver {
	
	func add<T: AnyObject>(_ builder: @escaping () -> T)
	func add<T: AnyObject>(_ builder: @autoclosure @escaping () -> T)
	
	func add<V, T>(_ type: T.Type, using builder: @escaping () -> V)
	func add<V, T>(_ type: T.Type, using builder: @autoclosure @escaping () -> V)
	
	func addBox<T>(_ builder: @escaping () -> T)
	func addBox<T>(_ builder: @autoclosure @escaping () -> T)
	
	func resolve<T>() -> T
	func resolve<T>(_ type: T.Type) -> T
	func resolveBox<T>() -> Box<T>
	func resolveBox<T>(_ type: T.Type) -> Box<T>
	
	func remove<T>(_ type: T.Type)
	
	func removeAll()
	
	func isAddedBox<T>(_ type: T.Type) -> Bool
}
public extension SingletonResolver {
	
	func add<T: AnyObject>(_ builder: @autoclosure @escaping () -> T) {
		self.add(builder)
	}
	
	func add<V, T>(_ type: T.Type, using builder: @autoclosure @escaping () -> V) {
		self.add(type, using: builder)
	}
	
	func addBox<T>(_ builder: @autoclosure @escaping () -> T) {
		self.addBox(builder)
	}
	
	func resolve<T>(_ type: T.Type) -> T {
		self.resolve()
	}
	
	func resolveBox<T>(_ type: T.Type) -> Box<T> {
		self.resolveBox()
	}
}
