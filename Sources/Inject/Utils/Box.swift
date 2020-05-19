//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 19/05/2020.
//

public class Box<T> {
	
	public var value: T
	
	public init(value: T) {
		self.value = value
	}
	
	public init(_ value: T) {
		self.value = value
	}
}
