import UIKit
//: ## Guided Tour: Error Handling
enum PrinterError: Error {
    case outOfPaper
    case noToner
    case onFire
}

func send(job: Int, toPrinter printerName: String) throws -> String {
    if printerName == "Never Has Toner" {
        throw PrinterError.noToner
    }
    return "Job sent"
}


//: 1.) Change the printer name to `"Never Has Toner"`, so that the `send(job:toPrinter:)` function throws an error.
//:

do {
    let printerResponse = try send(job: 1040, toPrinter: "Bi Sheng")
    print(printerResponse)
} catch {
    print(error)
}

//: 2.) Add code to throw an error inside the `do` block. Add an error so that the error is handled by the first `catch` block. Add more errors to trigger the second and third blocks.

do {
    let printerResponse = try send(job: 1440, toPrinter: "Gutenberg")
    print(printerResponse)
} catch PrinterError.onFire {
    print("I'll just put this over here, with the rest of the fire.")
} catch let printerError as PrinterError {
    print("Printer error: \(printerError).")
} catch {
    print(error)
}
//:
//: ## Swift Review Problem
//: You are going to write a GroceryTrip class that will serve as a data model for a grocery shopping app. The model will be instantiated for each grocery shopping trip. Assume there is only one grocery store, and there are never coupons. (It's a hard knock life.)
//: - You will need properties for the user's budget (A dollar amount), shopping list (a dictionary of GroceryItem: Bool (default the boolean to false)), a cart (an array of GroceryItem), the tax rate (a percentage), the total cost (a dollar amount), and the balance (a dollar amount).
//: - Your GroceryItem will have a name (a string), a quantity (an int), and a cost (a dollar amount). The shopping list will not know the cost of the items before the trip, so make cost an optional value. Write a mutating function that will update cost, and another to update quantity in case the grocery store does not have the items in stock.
//: - Write an GroceryTripError enum for the following cases: If the total exceeds the budget. If an item is selected that is not on the shopping list. If the quantity exceeds the required amount. If the quantity falls short of the required amount.
//: - Your class initializer will need the parameters for the user's budget and shopping list. The rest should default to logical values.
//: - Write a function to add a GroceryItem to the cart, which can throw an GroceryTripError. Take in the parameters for cost, quantity and item.
//: - - If the string does not match any of the GroceryItems in the shopping list dictionary, throw the appropriate error.
//: - - If the quantity does not match the GroceryItem's quantity in the shopping list dictionary, throw the appropriate error.
//: - - If the quantity matches, create the GroceryItem and add it to the cart array and update the dictionary's boolean to true. Update the total. If the total exceeds the budget, throw the appropriate error.
//:
//: - Write another function to remove an item from the cart. Take in the parameter of GroceryItem. Remove it from the array, and find the matching item in the shopping list (if it exists) and update the dictionary's boolean to false.
//: - Write a function to checkout that can throw an error. This function will return the remaining items on the shopping list and the remaining budget in a tuple. If the total exceeds the budget, throw the appropriate error. Otherwise, remove everything from the shopping list whose boolean evaluates to true and return everything on the shopping list that wasn't purchased, and return the remaining available budget amount. Do not return a dictionary, but return an array of GroceryItem.

