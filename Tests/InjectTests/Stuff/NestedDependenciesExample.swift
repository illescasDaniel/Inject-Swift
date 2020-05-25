//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 25/05/2020.
//

import Foundation
import Inject

struct Car {
	let brand: String
}
protocol CarRepository {
	func fetchCar(id: Int) -> Car
}
protocol Database {
	func executeRawSQL(_ sql: String) -> [Any]
}
class DefaultDatabase: Database {
	func executeRawSQL(_ sql: String) -> [Any] {
		return ["Toyot4"] /* ... */
	}
}
struct DefaultCarRepository: CarRepository {
	
	@Inject()
	private var database: Database
	
	init(database: Database?) {
		self.$database = database
	}
	
	func fetchCar(id: Int) -> Car {
		let carBrand = database.executeRawSQL("SELECT ... FROM BLABLABLALBLAB").first as! String
		return Car(brand: carBrand)
	}
}

struct NestedDependenciesExample {
	
	@Inject()
	private var carRepository: CarRepository
	
	init(carRepository: CarRepository?) {
		self.$carRepository = carRepository
	}
	
	func fetchCar(id: Int) -> Car {
		return carRepository.fetchCar(id: id)
	}
}
