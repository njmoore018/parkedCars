/*
    This is the car parking storage program!

    It is designed to fulfill a need for an apartment complex that needs
    to keep track of residents' cars and which ones are allowed to park
    in covered parking spaces (the resident pays a subscription fee for
    the covered parking privilege).

    You may begin by simply running the program, it will provide instructions
    on input as you go.
    Here are a few notes to prepare for using the program:
    1. Each car must have a valid license plate (contains only 6-7 alphanumeric characters)
       and the program automatically ensures that the input license plate of every car fits
       in those parameters.
    2. Each car must have a make, model, and color, but the program does not verify anything
       beyond that those are normal strings.
    3. Each car that is subscribed must have a valid input date for the subscription to expire.
       The program will verify that this date is correctly input in this format (mm/dd/yyyy)
       and that the date input is in the future (at least one day later than the current date).
    4. Every function that requires retrieval of a specific car only asks for the license plate
       number to retrieve that car. License plates are NOT case sensitive.

    Future Plans:
    - Implement saving to another file or database to store car data when the program is not running.

    Author: Nathan Moore
*/

import Foundation

// The main set to store all the residents' cars
var cars: Set<Car> = []

// The function to verify that a license plate only contains alphanumeric characters.
func isValidLicensePlate(licensePlateNum: String) -> Bool {
    let pattern = "^[A-Z0-9]+$"
    guard let regex = try? NSRegularExpression(pattern: pattern) else {
        return false
    }
    let range = NSRange(licensePlateNum.startIndex..<licensePlateNum.endIndex, in: licensePlateNum)
    return regex.firstMatch(in: licensePlateNum, options: [], range: range) != nil
}

// The function to get user input on a license plate, verify it fulfills all necessary parameters,
// then return the license plate with all letter characters capitalized.
func getValidLicensePlate() -> String {
    repeat {
        print("\nPlease enter the car's license plate number: ", terminator: "")
        // Set the plate variable to store the user input, check if it only contains alphanumeric characters.
        guard let plate = readLine()?.uppercased(), isValidLicensePlate(licensePlateNum: plate) else {
            print("\n\nInvalid license plate number! Must only include Letters and Integers.")
            print("\nPress Enter to try again...", terminator: "")
            let _ = readLine()
            print("\n" + String(repeating: "-", count: 50) + "\n")
            continue
        }
        // Check if the license plate only has 6 or 7 characters.
        guard plate.count == 6 || plate.count == 7 else {
            print("\n\nInvalid license plate number! Must be 6-7 characters long.")
            print("\nPress Enter to try again...", terminator: "")
            let _ = readLine()
            print("\n" + String(repeating: "-", count: 50) + "\n")
            continue
        }
        // Return the valid plate number.
        return plate
    } while true
}

// Ask the user to input a date, make sure it is in the proper format before returning the date.
func getValidDate() -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    repeat {
        print("\nPlease input the covered parking expiration date (mm/dd/yyyy): ", terminator: "")
        // Try to set the input to equal a date in the format of (mm/dd/yyyy)
        guard let input = readLine(), let date = dateFormatter.date(from: input) else {
            print("\n\n" + String(repeating: "-", count: 50))
            print("\nInvalid expiration date! Ensure date is in this format: mm/dd/yyyy")
            print("\nPress Enter to try again...", terminator: "")
            let _ = readLine()
            print("\n" + String(repeating: "-", count: 50) + "\n")
            continue
        }
        // If the input is a valid date in the correct format, return it.
        return date
    } while true
}

// This function checks if the date that was input is in the future (at least one day later than current date).
func getFutureDate() -> Date {
    repeat {
        // Call getValidDate to make sure the user inputs a proper date.
        let inputDate = getValidDate()
        let calendar = Calendar.current
        let currentDate = Date()
        let comparison = calendar.compare(inputDate, to: currentDate, toGranularity: .day)
        // Check if input date is at least one day in the future.
        guard comparison == .orderedDescending else {
            print("\n\n" + String(repeating: "-", count: 50))
            print("\nYou must input a future date! Please try again.")
            print("\nPress Enter to try again...", terminator: "")
            let _ = readLine()
            print("\n" + String(repeating: "-", count: 50) + "\n")
            continue
        }
        // If the input date is in the future, return it.
        return inputDate
    } while true
}

// This function relies upon all the functions above it to validate the user input for a car.
// It also allows the user to either add a car without a covered parking subscription or with one,
// dependent on the number they select in the options menu.
func addCar(subscribed: Bool = false) {
    print("\nAdding Car to Database:")
    print(String(repeating: "-", count: 50))
    // Use getValidLicensePlate to validate the input plate number before adding it to a car.
    let plate = getValidLicensePlate()
    print("\nPlease input the car's make: ", terminator: "")
    // Have the user input a string for the make.
    guard let make = readLine() else {
        print("\nError inputting car's make. Please try again.")
        return
    }
    print("\nPlease input the car's model: ", terminator: "")
    // Have the user input a string for the model.
    guard let model = readLine() else {
        print("\nError inputting car's model. Please try again.")
        return
    }
    print("\nPlease input the car's color: ", terminator: "")
    // Have the user input a string for the color.
    guard let color = readLine() else {
        print("\nError inputting car's color. Please try again.")
        return
    }
    // Date is nil unless the user chose to add a car and a subscription at the same time.
    var expirationDate: Date? = nil
    if subscribed {
        // If the user wants to add a subscription at the same time, use getFutureDate to validate
        // their input expiration date for the subscription.
        expirationDate = getFutureDate()
    }
    // Create the new car object and insert it into the Set.
    let newCar = Car(licensePlate: plate, make: make, model: model, color: color, subscribed: subscribed, expirationDate: expirationDate)
    cars.insert(newCar)
    print("\nCar successfully added to database!.\n")
    print("Returning to main menu...")
    print(String(repeating: "-", count: 50) + "\n" + String(repeating: "-", count: 50) + "\n")
}

// This is a simple function for formatting the expirationDates of cars into readable strings
// for the user to view when checking information on the cars.
func dateToString(date: Date?) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    if let date = date {
        return dateFormatter.string(from: date)
    } else {
        return nil
    }
}

// This function loops through all the cars in the set and neatly displays the information for any
// that have subscriptions to covered parking in a concise, organized manner for the user.
func showAllSubscribedCars () {
    // If there are no cars, provide a message informing the user and return to the main menu.
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
        // In the future, more functionality could be added here to print a message if there
        // are no subscribed cars in the set.
    }
    print("\n" + String(repeating: "-", count: 57) + "\n")
    print("\nPress Enter to return to menu...", terminator: "")
    let _ = readLine()
    print(String(repeating: "-", count: 50) + "\n" + String(repeating: "-", count: 50) + "\n\n")
}

// This function allows the user to input a license plate number for a car in the set and it will
// retrieve that car from the set for use in other functions.
func getSpecificCar() -> Car? {
    let plate = getValidLicensePlate()
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

// This function allows the user to update the subscription and expiration date of any car in the
// set. In the future, it could verify that newly input expiration dates are later dates than
// the previous expiration date.
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

// This function allows the user to see the expiration date for any given car. It will
// output a message letting the user know if the car they chose does not have a subscription.
func showExpirationDateOfCar(specificCar: Car?) {
    guard let car = specificCar else {
        return
    }
    if let date = dateToString(date: car.expirationDate) {
        print("\nExpiration Date: \(date)\n")
    } else {
        print("\nThat car does not have an active subscription!\n")
    }
    cars.insert(car)
    print("Press Enter to return to menu...", terminator: "")
    let _ = readLine()
    print(String(repeating: "-", count: 50) + "\n" + String(repeating: "-", count: 50) + "\n")
}

// This function neatly displays all the data for a specific car in the set
// (retrieved by license plate number).
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
    cars.insert(car)
    print("Press Enter to return to menu...", terminator: "")
    let _ = readLine()
    print(String(repeating: "-", count: 50) + "\n" + String(repeating: "-", count: 50) + "\n")
}

// This function neatly displays all cars from the set and all information for them.
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

// This function allows the user to delete any specific car from the set. It will output the data
// for the selected car (retrieved by license plate number) and ask the user to verify they want
// to delete it.
func deleteCar(specificCar: Car?) {
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
    print("\nAre you sure you want to delete? (Enter 'Y' to confirm. ", terminator: "")
    if let confirmation = readLine()?.uppercased, confirmation == "Y" {
        print("\nCar deleted!")
    } else {
        print("\nCar NOT deleted!")
        cars.insert(car)
    }
    print("\nPress Enter to return to menu...", terminator: "")
    let _ = readLine()
    print(String(repeating: "-", count: 50) + "\n" + String(repeating: "-", count: 50) + "\n\n")
}

// This variable controls the main loop for the program. The user must select the last option
// in the optionsList to set this to false and end the program.
var running = true

// The list of options for the main menu.
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

// The main loop for the program.
while running {
    print("\nPlease choose a number from the following list:")
    print(String(repeating: "-", count: 47) + "\n")
    for i in 1...optionsList.count {
        print("    \(i)) \(optionsList[i-1])")
    }
    print("\n>> ", terminator: "")
    
    // Input checking to verify that the user input a number.
    guard let input = readLine(), let number = Int(input) else {
        print("\nYou must enter a valid integer! Please try again.\n")
        print("Press Enter to try again...", terminator: "")
        let _ = readLine()
        print(String(repeating: "-", count: 50) + "\n" + String(repeating: "-", count: 50) + "\n\n")
        continue
    }
    switch number {

    // Add new car without subscription.
    case 1:
        addCar()
    
    // Add new car with subscription.
    case 2:
        addCar(subscribed: true)

    // Add/update subscription of a car.
    case 3:
        print("\nUpdating Subscription of Car:")
        print(String(repeating: "-", count: 50))
        addSubscriptionToCar(specificCar: getSpecificCar())

    // Show expiration date of a car's subscription.
    case 4:
        print("\nShowing Expiration Date of Car:")
        print(String(repeating: "-", count: 50))
        showExpirationDateOfCar(specificCar: getSpecificCar())

    // Show all cars with subscriptions.
    case 5:
        showAllSubscribedCars()

    // Show all details of a specific car.
    case 6:
        showAllDetailsOfCar(specificCar: getSpecificCar())

    // Show all cars in the set.
    case 7:
        showAllCars()

    // Delete a car from the set.
    case 8:
        deleteCar(specificCar: getSpecificCar())

    // Exit the program.
    case 9:
        print("\nExiting program...\n")
        running = false
        
    default:
        // This is the default for inputting any number that isn't present on the options list.
        print("\nInput number must be between 1 and \(optionsList.count)! Please try again.\n")
        print("Press Enter to try again...", terminator: "")
        let _ = readLine()
        print(String(repeating: "-", count: 50) + "\n" + String(repeating: "-", count: 50) + "\n\n")
    }
}
