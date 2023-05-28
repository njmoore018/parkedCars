
// Apartment Parking Project by Nathan Moore

import Foundation

class Car: Equatable, Hashable {
    let licensePlate: String
    let make: String
    let model: String
    let color: String
    var subscribed: Bool
    var expirationDate: Date?
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

    static func == (lhs: Car, rhs: Car) -> Bool {
        return lhs.licensePlate == rhs.licensePlate
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(licensePlate)
    }
}