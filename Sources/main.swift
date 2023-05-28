import Foundation

var cars: Set<Car> = []

func isCorrectLicensePlate(licensePlateNum: String) -> Bool {
    let pattern = "^[A-Z0-9]+$"
    guard let regex = try? NSRegularExpression(pattern: pattern) else {
        return false
    }
    let range = NSRange(licensePlateNum.startIndex..<licensePlateNum.endIndex, in: licensePlateNum)
    return regex.firstMatch(in: licensePlateNum, options: [], range: range) != nil
}

func getCorrectLicensePlate() -> String {
    repeat {
        print("\nPlease enter the car's license plate number: ", terminator: "")
        guard let plate = readLine()?.uppercased(), isCorrectLicensePlate(licensePlateNum: plate) else {
            print("\n\nInvalid license plate number! Must only include Letters and Integers.")
            print("\nPress Enter to try again...", terminator: "")
            let _ = readLine()
            print("\n" + String(repeating: "-", count: 50) + "\n")
            continue
        }
        guard plate.count == 6 || plate.count == 7 else {
            print("\n\nInvalid license plate number! Must be 6-7 characters long.")
            print("\nPress Enter to try again...", terminator: "")
            let _ = readLine()
            print("\n" + String(repeating: "-", count: 50) + "\n")
            continue
        }
        return plate
    } while true
}

func getCorrectDate() -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "mm/dd/yyyy"
    repeat {
        print("\nPlease input the covered parking expiration date (mm/dd/yyyy): ", terminator: "")
        guard let input = readLine(), let date = dateFormatter.date(from: input) else {
            print("\n\n" + String(repeating: "-", count: 50))
            print("\nInvalid expiration date! Ensure date is in this format: mm/dd/yyyy")
            print("\nPress Enter to try again...", terminator: "")
            let _ = readLine()
            print("\n" + String(repeating: "-", count: 50) + "\n")
            continue
        }
        return date
    } while true
}

func getFutureDate() -> Date {
    repeat {
        let inputDate = getCorrectDate()
        let calendar = Calendar.current
        let currentDate = Date()
        let comparison = calendar.compare(inputDate, to: currentDate, toGranularity: .day)
        guard comparison == .orderedDescending else {
            print("\n\n" + String(repeating: "-", count: 50))
            print("\nYou must input a future date! Please try again.")
            print("\nPress Enter to try again...", terminator: "")
            let _ = readLine()
            print("\n" + String(repeating: "-", count: 50) + "\n")
            continue
        }
        return inputDate
    } while true
}

func addCar(subscribed: Bool = false) {
    print("\nAdding Car to Database:")
    print(String(repeating: "-", count: 50))
    let plate = getCorrectLicensePlate()
    print("\nPlease input the car's make: ", terminator: "")
    guard let make = readLine() else {
        print("\nError inputting car's make. Please try again.")
        return
    }
    print("\nPlease input the car's model: ", terminator: "")
    guard let model = readLine() else {
        print("\nError inputting car's model. Please try again.")
        return
    }
    print("\nPlease input the car's color: ", terminator: "")
    guard let color = readLine() else {
        print("\nError inputting car's color. Please try again.")
        return
    }
    var expirationDate: Date? = nil
    if subscribed {
        expirationDate = getCorrectDate()
    }
    let newCar = Car(licensePlate: plate, make: make, model: model, color: color, subscribed: subscribed, expirationDate: expirationDate)
    cars.insert(newCar)
    print("\nCar successfully added to database!.\n")
    print("Returning to main menu...")
    print(String(repeating: "-", count: 50) + "\n" + String(repeating: "-", count: 50) + "\n")
}

func dateToString(date: Date?) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "mm/dd/yyyy"
    if let date = date {
        return dateFormatter.string(from: date)
    } else {
        return nil
    }
}

func showAllSubscribedCars () {
    if cars.count < 1 {
        print("\nSorry, there are no cars in the database.\n")
        print("Press Enter to return to menu...", terminator: "")
        let _ = readLine()
        print(String(repeating: "-", count: 50) + "\n" + String(repeating: "-", count: 50) + "\n\n")
        return
    }
    print("\nHere is a list of all cars subscribed to covered parking:")
    print(String(repeating: "-", count: 57) + "\n")
    print("License Plate:       Expiration Date:\n")
    for car in cars {
        if car.subscribed {
            let plate = car.licensePlate.padding(toLength: 21, withPad: " ", startingAt: 0)
            if let expirationDate = dateToString(date: car.expirationDate) {
                print("\(plate)\(expirationDate)")
            } else {
                print("Error( License Plate: \(car.licensePlate) has active subscription without valid expiration date.)")
            }
        }
    }
    print("\n" + String(repeating: "-", count: 57) + "\n")
    print("\nPress Enter to return to menu...", terminator: "")
    let _ = readLine()
    print(String(repeating: "-", count: 50) + "\n" + String(repeating: "-", count: 50) + "\n\n")
}

func getSpecificCar() -> Car? {
    let plate = getCorrectLicensePlate()
    guard let carIndex = cars.firstIndex(where: { $0.licensePlate == plate }) else {
        print("\nSorry, no car exists in the database with that license plate. Please try again.\n")
        print("\nPress Enter to return to menu...", terminator: "")
        let _ = readLine()
        print(String(repeating: "-", count: 50) + "\n" + String(repeating: "-", count: 50) + "\n\n")
        return nil
    }
    let car = cars.remove(at: carIndex)
    return car
}

func addSubscriptionToCar(specificCar: Car?) {
    guard let car = specificCar else {
        return
    }
    car.subscribed = true
    car.expirationDate = getFutureDate()
    cars.insert(car)
    print("\nCar subscription updated!.\n")
    print("Returning to main menu...")
    print(String(repeating: "-", count: 50) + "\n" + String(repeating: "-", count: 50) + "\n")
}

func showExpirationDateOfCar(specificCar: Car?) {
    guard let car = specificCar else {
        return
    }
    if let date = dateToString(date: car.expirationDate) {
        print("\nExpiration Date: \(date)\n")
    } else {
        print("\nThat car does not have an active subscription!\n")
    }
    print("Press Enter to return to menu...", terminator: "")
    let _ = readLine()
    print(String(repeating: "-", count: 50) + "\n" + String(repeating: "-", count: 50) + "\n")
}

func showAllDetailsOfCar(specificCar: Car?) {
    guard let car = specificCar else {
        return
    }
    print("\nAll details for that car:")
    print(String(repeating: "-", count: 50) + "\n")
    print("License Plate: \(car.licensePlate)")
    print("Make: \(car.make)")
    print("Model: \(car.model)")
    print("Color: \(car.color)")
    var subbed = "No"
    if car.subscribed {
        subbed = "Yes"
    }
    print("Subscribed to covered parking: \(subbed)")
    if let date = dateToString(date: car.expirationDate) {
        print("Covered parking expiration: \(date)")
    }
    print("\n" + String(repeating: "-", count: 57) + "\n")
    print("Press Enter to return to menu...", terminator: "")
    let _ = readLine()
    print(String(repeating: "-", count: 50) + "\n" + String(repeating: "-", count: 50) + "\n")
}

func showAllCars() {
    if cars.count < 1 {
        print("\nSorry, there are no cars in the database.\n")
        print("Press Enter to return to menu...", terminator: "")
        let _ = readLine()
        print(String(repeating: "-", count: 50) + "\n" + String(repeating: "-", count: 50) + "\n\n")
        return
    }
    print("\nHere are all residents' cars:")
    print(String(repeating: "-", count: 57) + "\n")
    print("License Plate:   Make, Model:           Color:       Covered Parking:   Expiration:\n")
    for car in cars {
        let plate = car.licensePlate.padding(toLength: 16, withPad: " ", startingAt: 0)
        let make = car.make
        let model = car.model
        let makeModel = ("\(make) \(model)").padding(toLength: 22, withPad: " ", startingAt: 0)
        let color = car.color.padding(toLength: 12, withPad: " ", startingAt: 0)
        var subbed = "No"
        if car.subscribed { subbed = "Yes" }
        let paddedSubbed = subbed.padding(toLength: 18, withPad: " ", startingAt: 0)
        let date = dateToString(date: car.expirationDate) ?? "N/A"
        let output = "\(plate) \(makeModel) \(color) \(paddedSubbed) \(date)"
        print(output)
    }
    print("\n" + String(repeating: "-", count: 57) + "\n")
    print("\nPress Enter to return to menu...", terminator: "")
    let _ = readLine()
    print(String(repeating: "-", count: 50) + "\n" + String(repeating: "-", count: 50) + "\n\n")
}

var running = true
let optionsList = [
    "Add new resident car (without covered parking).",
    "Add new resident car (with covered parking).",
    "Add or extend covered parking on existing car.",
    "See covered parking expiration date of a car.",
    "See covered parking expiration dates of all cars.",
    "See all details of a specific car.",
    "See all cars in database.",
    "Delete a car from the database.",
    "Exit program."]

print("\nHello and welcome to the parking tracker program!")

while running {
    print("\nPlease choose a number from the following list:")
    print(String(repeating: "-", count: 47) + "\n")
    for i in 1...optionsList.count {
        print("    \(i)) \(optionsList[i-1])")
    }
    print("\n>> ", terminator: "")
    guard let input = readLine(), let number = Int(input) else {
        print("\nYou must enter a valid integer! Please try again.\n")
        print("Press Enter to try again...", terminator: "")
        let _ = readLine()
        print(String(repeating: "-", count: 50) + "\n" + String(repeating: "-", count: 50) + "\n\n")
        continue
    }
    switch number {
    case 1:
        addCar()
    case 2:
        addCar(subscribed: true)
    case 3:
        print("\nAdding Subscription to Car:")
        print(String(repeating: "-", count: 50))
        addSubscriptionToCar(specificCar: getSpecificCar())
    case 4:
        print("\nShowing Expiration Date of Car:")
        print(String(repeating: "-", count: 50))
        showExpirationDateOfCar(specificCar: getSpecificCar())
    case 5:
        showAllSubscribedCars()
    case 6:
        showAllDetailsOfCar(specificCar: getSpecificCar())
    case 7:
        showAllCars()
    case 8:
        // Display all details of selected car and then ask if they're sure they want to delete
        print("\nSorry, this feature hasn't been implemented yet. Please try a different number.\n")
    case 9:
        print("\nExiting program...\n")
        running = false
    default:
        print("\nInput number must be between 1 and \(optionsList.count)! Please try again.\n")
        print("Press Enter to try again...", terminator: "")
        let _ = readLine()
        print(String(repeating: "-", count: 50) + "\n" + String(repeating: "-", count: 50) + "\n\n")
    }
}
