
// Apartment Parking Storage Project by Nathan Moore

import Foundation

// This is the class that is used by almost all functions in the 'main.swift' file.
class Car: Equatable, Hashable {
    let licensePlate: String
    let make: String
    let model: String
    let color: String
    var subscribed: Bool
    var expirationDate: Date?
    
    // This function is not currently in use, but it is here for potential future features. Such as
    // a function quickly checking all cars for expiration and displaying all expired subscriptions.
    var subscriptionExpired: Bool {
        if let expirationDate = expirationDate {
            return Date() >= expirationDate 
        } else {
            print("Error: Cannot check if a car's covered parking has expired if resident has not subscribed to have covered parking.")
            return false
        }
    }

    init(licensePlate: String, make: String, model: String, color: String, subscribed: Bool, expirationDate: Date?) {
        self.licensePlate = licensePlate
        self.make = make
        self.model = model
        self.color = color
        self.subscribed = subscribed
        self.expirationDate = expirationDate
    }

    // Required for conformance to the Equatable protocol, parent to Hashable protocol
    static func == (lhs: Car, rhs: Car) -> Bool {
        return lhs.licensePlate == rhs.licensePlate
    }

    // Required for conformance to the Hasher protocol, necessary for objects to be inserted
    // into a set (how the cars are stored in the other file)
    func hash(into hasher: inout Hasher) {
        hasher.combine(licensePlate)
    }
}