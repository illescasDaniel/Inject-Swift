//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 19/05/2020.
//

import Foundation

public protocol Resolver {
	func resolve<T>() -> T
	func resolve<T>(_ type: T.Type) -> T
	
	func isAdded<T>(_ type: T.Type) -> Bool
}
