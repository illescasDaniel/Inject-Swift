//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 19/05/2020.
//

public protocol DependencyResolver: Resolver {
	
	func add<T>(_ builder: @escaping () -> T)
	func add<T>(_ builder: @autoclosure @escaping () -> T)
	
	func add<T>(_ type: T.Type, using builder: @escaping @autoclosure () -> T)
	func add<T>(_ type: T.Type, using builder: @escaping () -> T)
	
	func resolve<T>(_ type: T.Type) -> T
	func resolve<T>() -> T
	
	func remove<T>(_ type: T.Type)
	
	func removeAll()
}
public extension DependencyResolver {
	
	func add<T>(_ builder: @autoclosure @escaping () -> T) {
		self.add(T.self, using: builder)
	}
	
	func add<T>(_ type: T.Type, using builder: @escaping @autoclosure () -> T) {
		self.add(type, using: builder)
	}
	
	func resolve<T>(_ type: T.Type) -> T {
		return self.resolve()
	}
}
