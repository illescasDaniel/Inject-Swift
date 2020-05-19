//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 19/05/2020.
//

@propertyWrapper
public struct InjectSingleton<T> {
	
	@Lazy
	private var value: T
	
	public init(resolver: SingletonResolver) {
		self.$value = { resolver.resolve(T.self) }
	}
	
	public var wrappedValue: T {
		get { value }
		set { value = newValue }
	}
	
	public var projectedValue: T? {
		get { value }
		set {
			if let validValue = newValue {
				value = validValue
			}
		}
	}
}
