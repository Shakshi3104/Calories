//
//  EnergyObserver.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/02/21.
//

import HealthKit

// MARK: - HealthObserver
class HealthObserver {
    /// - Tag: Health Store
    let healthStore: HKHealthStore
    
    init() {
        self.healthStore = HKHealthStore()
    }
    
    private func getStatistics(date: Date, quantityType: HKQuantityType, unit: HKUnit, completion: @escaping (Int) -> ()) {
        let startDate = Calendar.current.startOfDay(for: date)
        let endDate = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: startDate) ?? date)
        
        print("📆 start: \(startDate) - end: \(endDate)")
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        let interval = DateComponents(day: 1)
        
        let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                quantitySamplePredicate: predicate,
                                                options: .cumulativeSum,
                                                anchorDate: startDate,
                                                intervalComponents: interval)
        query.initialResultsHandler = { query, collection, error in
            guard let statsCollection = collection else {
                return
            }
            
            statsCollection.enumerateStatistics(from: startDate, to: endDate) { stats, stop in
                if let quantity = stats.sumQuantity() {
                    let date = stats.startDate
                    let value = quantity.doubleValue(for: unit)
                    print("🍎 date: \(date), \(value) \(unit.unitString)")
                    
                    completion(Int(value))
                }
            }
        }
        
        healthStore.execute(query)
    }
}

// MARK: - HealthObserver extension : Energy
extension HealthObserver {
    
    func getActiveEnergy(date: Date, completion: @escaping (Int) -> ()) {
        let activeEnergy: HKQuantityType? = HKQuantityType(.activeEnergyBurned)
        
        if let activeEnergy = activeEnergy {
            getStatistics(date: date, quantityType: activeEnergy, unit: .largeCalorie(), completion: completion)
        }
    }
    
    func getDietaryEnergy(date: Date, completion: @escaping (Int) -> ()) {
        let dietaryEnergy: HKQuantityType? = HKQuantityType(.dietaryEnergyConsumed)
        
        if let dietaryEnergy = dietaryEnergy {
            getStatistics(date: date, quantityType: dietaryEnergy, unit: .largeCalorie(), completion: completion)
        }
    }
    
    func getRestingEnergy(date: Date, completion: @escaping (Int) -> ()) {
        let baselEnergy: HKQuantityType? = HKQuantityType(.basalEnergyBurned)
        
        if let baselEnergy = baselEnergy {
            getStatistics(date: date, quantityType: baselEnergy, unit: .largeCalorie(), completion: completion)
        }
    }
    
    // MARK: - Energy
    func getEnergy(date: Date, completion: @escaping ((Int, Int, Int)) -> ()) {
        self.getRestingEnergy(date: date) { [self] resting in
            self.getActiveEnergy(date: date) { [self] active in
                self.getDietaryEnergy(date: date) { dietary in
                    completion((resting, active, dietary))
                }
            }
        }
    }
    
    func getEnergyWithRequestingAuthorization(date: Date, completion: @escaping ((Int, Int, Int)) -> ()) {
        // The quantity types to read from the health store
        let typesToRead: Set = [
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.dietaryEnergyConsumed),
            HKQuantityType(.basalEnergyBurned)
        ]
        
        // Request authorization
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            if !success {
                print("Not allow")
            } else {
                print("Success!")
                self.getEnergy(date: date, completion: completion)
            }
        }
    }
    
    func getEnergyWithRequestStatus(date: Date, completion: @escaping ((Int, Int, Int)) -> ()) {
        // The quantity types to read from the health store
        let typesToRead: Set = [
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.dietaryEnergyConsumed),
            HKQuantityType(.basalEnergyBurned)
        ]
        
        healthStore.getRequestStatusForAuthorization(toShare: Set(), read: typesToRead) { success, error in
            switch success {
            case .shouldRequest:
                print("Calories has not yet requested authorization.")
            case .unnecessary:
                print("Calories has already requested authorization.")
                self.getEnergy(date: date, completion: completion)
            case .unknown:
                print("Unkown authorization request status")
            @unknown default:
                fatalError()
            }
        }
    }
}

// MARK: - HealthObserver extension : Energy async
extension HealthObserver {
    
    func getActiveEnergy(date: Date) async  -> Int {
        await withCheckedContinuation({ continuation in
            getActiveEnergy(date: date) { value in
                continuation.resume(returning: value)
            }
        })
    }
    
    func getDietaryEnergy(date: Date) async -> Int {
        await withCheckedContinuation({ continuation in
            getDietaryEnergy(date: date) { value in
                continuation.resume(returning: value)
            }
        })
    }
    
    func getRestingEnergy(date: Date) async -> Int {
        await withCheckedContinuation({ continuation in
            getRestingEnergy(date: date) { value in
                continuation.resume(returning: value)
            }
        })
    }
}

// MARK: - HealthObserver extension : Nutrition
extension HealthObserver {
    
    func getProtein(date: Date, completion: @escaping (Int) -> ()) {
        let protein: HKQuantityType? = HKQuantityType(.dietaryProtein)
        
        if let protein = protein {
            getStatistics(date: date, quantityType: protein, unit: .gram(), completion: completion)
        }
    }
    
    func getCarbohydrates(date: Date, completion: @escaping (Int) -> ()) {
        let carbohydrates: HKQuantityType? = HKQuantityType(.dietaryCarbohydrates)
        
        if let carbohydrates = carbohydrates {
            getStatistics(date: date, quantityType: carbohydrates, unit: .gram(), completion: completion)
        }
    }
    
    func getFatTotal(date: Date, completion: @escaping (Int) -> ()) {
        let fatTotal: HKQuantityType? = HKQuantityType(.dietaryFatTotal)
        
        if let fatTotal = fatTotal {
            getStatistics(date: date, quantityType: fatTotal, unit: .gram(), completion: completion)
        }
    }
    
    // MARK: - Nutrition
    func getBasicNutrition(date: Date, completion: @escaping ((Int, Int, Int)) -> ()) {
        self.getProtein(date: date) { [self] protein in
            self.getCarbohydrates(date: date) { [self] carbohydrates in
                self.getFatTotal(date: date) { fatTotal in
                    completion((protein, carbohydrates, fatTotal))
                }
            }
        }
    }
    
    func getBasicNutritionWithRequestingAuthorization(date: Date, completion: @escaping ((Int, Int, Int)) -> ()) {
        // The quantity types to read from the health store
        let typesToRead: Set = [
            HKQuantityType(.dietaryProtein),
            HKQuantityType(.dietaryCarbohydrates),
            HKQuantityType(.dietaryFatTotal)
        ]
        
        // Request authorization
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            if !success {
                print("Not allow")
            } else {
                print("Success!")
                self.getBasicNutrition(date: date, completion: completion)
            }
        }
    }
    
    func getBasicNutritionWithRequestStatus(date: Date, completion: @escaping ((Int, Int, Int)) -> ()) {
        // The quantity types to read from the health store
        let typesToRead: Set = [
            HKQuantityType(.dietaryProtein),
            HKQuantityType(.dietaryCarbohydrates),
            HKQuantityType(.dietaryFatTotal)
        ]
        
        healthStore.getRequestStatusForAuthorization(toShare: Set(), read: typesToRead) { success, error in
            switch success {
            case .shouldRequest:
                print("Calories has not yet requested authorization.")
            case .unnecessary:
                print("Calories has already requested authorization.")
                self.getBasicNutrition(date: date, completion: completion)
            case .unknown:
                print("Unkown authorization request status")
            @unknown default:
                fatalError()
            }
        }
    }
}

// MARK: - HealthObserver extention: Nutrition async
extension HealthObserver {
    
    func getProtein(date: Date) async -> Int {
        await withCheckedContinuation({ continuation in
            getProtein(date: date) { value in
                continuation.resume(returning: value)
            }
        })
    }
    
    func getCabohydrates(date: Date) async -> Int {
        await withCheckedContinuation({ continuation in
            getCarbohydrates(date: date) { value in
                continuation.resume(returning: value)
            }
        })
    }
    
    func getFatTotal(date: Date) async -> Int {
        await withCheckedContinuation({ continuation in
            getFatTotal(date: date) { value in
                continuation.resume(returning: value)
            }
        })
    }
}

// MARK: - HealthModel
class HealthModel: ObservableObject {
    /// Published
    @Published var energy: Energy = Energy(resting: 0, active: 0, dietary: 0)
    @Published var basicNutrition: BasicNutrition = BasicNutrition(protein: 0, carbohydrates: 0, fatTotal: 0)
    
    /// Observer
    let healthObserver = HealthObserver()
    
    func updateEnergy(date: Date = Date()) {
        healthObserver.getEnergyWithRequestingAuthorization(date: date) { (resting, active, dietary) -> Void in
            print("🍎 \(resting), \(active), \(dietary)")
            
            DispatchQueue.main.async {
                self.energy = Energy(resting: resting, active: active, dietary: dietary)
            }
        }
    }
    
    func updateBasicNutrition(date: Date = Date()) {
        healthObserver.getBasicNutritionWithRequestingAuthorization(date: date) { (protein, carbohydrates, fatTotal) in
            print("🍇 \(protein), \(carbohydrates), \(fatTotal)")
            
            DispatchQueue.main.async {
                self.basicNutrition = BasicNutrition(protein: protein, carbohydrates: carbohydrates, fatTotal: fatTotal)
            }
        }
    }
}

// MARK: - HealthModel extension: async
extension HealthModel {
    func updateEnergy(date: Date = Date()) async {
        let resting = await healthObserver.getRestingEnergy(date: date)
        let active = await healthObserver.getActiveEnergy(date: date)
        let dietary = await healthObserver.getDietaryEnergy(date: date)
        
        print("🍎🍎 \(resting), \(active), \(dietary)")
        
        DispatchQueue.main.async {
            self.energy = Energy(resting: resting, active: active, dietary: dietary)
        }
    }
    
    func updateBasicNutrition(date: Date = Date()) async {
        let protein = await healthObserver.getProtein(date: date)
        let carbohydrates = await healthObserver.getCabohydrates(date: date)
        let fatTotal = await healthObserver.getFatTotal(date: date)
        
        print("🍇🍇 \(protein), \(carbohydrates), \(fatTotal)")
        
        DispatchQueue.main.async {
            self.basicNutrition = BasicNutrition(protein: protein, carbohydrates: carbohydrates, fatTotal: fatTotal)
        }
    }
}
