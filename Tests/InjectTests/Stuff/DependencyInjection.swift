//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 19/05/2020.
//

import Inject

class DependencyInjection {
	static let dependencies: DependencyResolver = DefaultDependencyResolver()
	static let singletons: SingletonResolver = DefaultSingletonResolver()
}

