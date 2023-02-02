//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 19/05/2020.
//

@propertyWrapper
internal class Lazy<T> {

	private var builder: (() -> T)
	private lazy var value: T = self.builder()

	internal init(builder: @escaping () -> T) {
		self.builder = builder
	}

	internal var wrappedValue: T {
		get { self.value }
		set { value = newValue }
	}
}
