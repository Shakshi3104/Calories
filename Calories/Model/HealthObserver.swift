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
}

// MARK: - HealthObserver extension : Energy
extension HealthObserver {
    private func getEnergyStatistics(quantityType: HKQuantityType, completion: @escaping (Int) -> ()) {
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        
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
                    let value = quantity.doubleValue(for: .largeCalorie())
                    print("🍎 date: \(date), \(value) kcal")
                    
                    completion(Int(value))
                }
            }
        }
        
        healthStore.execute(query)
    }
    
    func getActiveEnergy(completion: @escaping (Int) -> ()) {
        let activeEnergy: HKQuantityType? = HKQuantityType(.activeEnergyBurned)
        
        if let activeEnergy = activeEnergy {
            getEnergyStatistics(quantityType: activeEnergy, completion: completion)
        }
    }
    
    func getDietaryEnergy(completion: @escaping (Int) -> ()) {
        let dietaryEnergy: HKQuantityType? = HKQuantityType(.dietaryEnergyConsumed)
        
        if let dietaryEnergy = dietaryEnergy {
            getEnergyStatistics(quantityType: dietaryEnergy, completion: completion)
        }
    }
    
    func getRestingEnergy(completion: @escaping (Int) -> ()) {
        let baselEnergy: HKQuantityType? = HKQuantityType(.basalEnergyBurned)
        
        if let baselEnergy = baselEnergy {
            getEnergyStatistics(quantityType: baselEnergy, completion: completion)
        }
    }
    
    // MARK: - Energy
    func getEnergy(completion: @escaping ((Int, Int, Int)) -> ()) {
        self.getRestingEnergy { [self] resting in
            self.getActiveEnergy { [self] active in
                self.getDietaryEnergy { dietary in
                    completion((resting, active, dietary))
                }
            }
        }
    }
    
    func getEnergyWithRequestingAuthorization(completion: @escaping ((Int, Int, Int)) -> ()) {
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
                self.getEnergy(completion: completion)
            }
        }
    }
    
    func getEnergyWithRequestStatus(completion: @escaping ((Int, Int, Int)) -> ()) {
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
                self.getEnergy(completion: completion)
            case .unknown:
                print("Unkown authorization request status")
            @unknown default:
                fatalError()
            }
        }
    }
}

// MARK: - HealthObserver extension : async
extension HealthObserver {
    
    func getActiveEnergy() async  -> Int {
        await withCheckedContinuation({ continuation in
            getActiveEnergy { value in
                continuation.resume(returning: value)
            }
        })
    }
    
    func getDietaryEnergy() async -> Int {
        await withCheckedContinuation({ continuation in
            getDietaryEnergy { value in
                continuation.resume(returning: value)
            }
        })
    }
    
    func getRestingEnergy() async -> Int {
        await withCheckedContinuation({ continuation in
            getRestingEnergy { value in
                continuation.resume(returning: value)
            }
        })
    }
}

// MARK: - HealthObserver extension : Nutrition
extension HealthObserver {
    
}

// MARK: - HealthModel
class HealthModel: ObservableObject {
    /// Published
    @Published var energy: Energy = Energy(resting: 0, active: 0, dietary: 0)
    @Published var basicNutrition: BasicNutrition = BasicNutrition(protein: 0, carbohydrates: 0, fatTotal: 0)
    
    /// Observer
    let healthObserver = HealthObserver()
    
    func updateEnergy() async {
        let resting = await healthObserver.getRestingEnergy()
        let active = await healthObserver.getActiveEnergy()
        let dietary = await healthObserver.getDietaryEnergy()
    
        print("🍎 \(resting), \(active), \(dietary)")
        
        DispatchQueue.main.async {
            self.energy = Energy(resting: resting, active: active, dietary: dietary)
        }
    }
    
    func updateEnergy() {
        healthObserver.getEnergyWithRequestingAuthorization { (resting, active, dietary) -> Void in
            print("🍎 \(resting), \(active), \(dietary)")
            
            DispatchQueue.main.async {
                self.energy = Energy(resting: resting, active: active, dietary: dietary)
            }
        }
    }
}
