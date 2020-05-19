//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 19/05/2020.
//

import Inject

extension Inject {
	init() {
		self.init(resolver: DependencyInjection.dependencies)
	}
}
extension InjectSingleton {
	init() {
		self.init(resolver: DependencyInjection.singletons)
	}
}
extension AutoWired {
	init() {
		self.init(resolver: DependencyInjection.dependencies)
	}
}
extension AutoWiredSingleton {
	init() {
		self.init(resolver: DependencyInjection.singletons)
	}
}
extension AutoWiredBoxSingleton {
	init() {
		self.init(resolver: DependencyInjection.singletons)
	}
}
