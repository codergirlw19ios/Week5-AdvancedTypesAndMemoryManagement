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
//:
//: ## Swift Review Problem
//: You are going to write a GroceryTrip class that will serve as a data model for a grocery shopping app. The model will be instantiated for each grocery shopping trip. Assume there is only one grocery store, and there are never coupons. (It's a hard knock life.)
//: - You will need properties for the user's budget (A dollar amount), shopping list (a dictionary of GroceryItem: Bool (default the boolean to false)), a cart (an array of GroceryItem), the tax rate (a percentage), the total cost (a dollar amount), and the balance (a dollar amount). Only the model should be able to update and access them with the exception of total cost and balance; set the access modifiers accordingly.
//: - Total cost and balance should be a read-only computed variables. The logic for total cost should use the reduce higher order function on the cart. If an item has no cost stored in the optional value, return the accumulating total. Otherwise, return the cost of the item multiplied times it's quantity added to the accumulating total. After you complete the reduce method, multiply the result with the tax rate and return the total as the computed value. The logic for balance should simply subtract the total from the budget.
//: - - In order to use your own struct as a key in a dictionary you will have to conform to the protocol Hashable. Thankfully the properties used on this struct already conform to Hashable, so all you have to do is let the compiler know that GroceryItem can conform to Hashable as well.
//:
//: - Your GroceryItem will have a name (a string), a quantity (an int), and a cost (a dollar amount). The shopping list will not know the cost of the items before the trip, so make cost an optional value. Write a mutating function that will update cost, and another to update quantity in case the grocery store does not have the items in stock.
//: - Write an GroceryTripError enum that conforms to the Error protocol for the following cases: If the total exceeds the budget. If an item is selected that is not on the shopping list. If the quantity exceeds the required amount. If the quantity falls short of the required amount. If the tax rate is 0.0.
//: - Your class initializer will need the parameters for the user's budget (a dollar amount) and shopping list (an array of GroceryItem) and a tax rate with a default value of 0.0. You will need to convert the shoppingList array to a dictionary yourself. The rest that are not computed variables should default to logical values.
//: - Converting the array of your own struct to a dictionary requires a few steps. The easiest way to do this is to first ensure your array contains unique values by initializing a Set from your array. Then map over the set and and return a tuple that represent the key-value pair that you want to be your dictionary item. Then use the Dictionary(uniqueKeysWithValues) initializer and pass in your array of tuples that you received from the map high order function.
//: - Write a function to add a GroceryItem to the cart, which can throw an GroceryTripError. Take in the parameters for cost, quantity and item.
//: - - If the string does not match any of the GroceryItems' names in the shopping list dictionary, throw the appropriate error.
//: - - If the quantity does not match the GroceryItem's quantity in the shopping list dictionary, throw the appropriate error.
//: - - If the quantity matches, update the dictionary's boolean to true and add the GroceryItem with cost to the cart array. Check the new balance and throw an error if necessary.
//:
//: - Write another function to remove an item from the cart. Take in the parameter of GroceryItem. Remove it from the array, and find the matching item in the shopping list (if it exists) and update the dictionary's boolean to false.
///: - Write a function to checkout that can throw an error. This function will return the remaining items on the shopping list and the remaining budget in a tuple. If the tax rate is 0.0, return the appropriate error. If the balance is negative, throw the appropriate error. Otherwise, remove everything from the shopping list whose boolean evaluates to true and return everything on the shopping list that wasn't purchased, and return the remaining available budget amount. Do not return a dictionary, but return an array of GroceryItem.
//: - Write another function to update the tax rate that can throw an error. Take in the appropriate parameter. Be sure to update the total. Throw an error if the new total exceeds the budget.


enum GroceryTripError: Error {
    case exceedsBudget
    case itemNotInShoppingList
    case itemQuantityExceedsRequiredAmount
    case itemQuantityFallsShortOfRequiredAmount
}

struct GroceryItem {
    let name: String
    var quantity: Int
    var cost: Double?

    mutating func update(cost: Double){
        self.cost = cost
    }

    mutating func update(quantity: Int){
        self.quantity = quantity
    }
}

class GroceryTrip {
    private var budget: Double
    private var shoppingList: [GroceryItem: Bool]
    private var cart: [GroceryItem]
    private var taxRate: Double
    private var totalCost: Double {
        return cart.reduce(0.0) { totalCost, groceryItem in
            guard let cost = groceryItem.cost else { return totalCost }

            return totalCost + ( cost * Double(groceryItem.quantity))
        }
    }

    var balance: Double { return budget - totalCost }

    init(budget: Double, shoppingList: [GroceryItem]) {
        self.budget = budget
        cart = []
        taxRate = 0.0

        let keyValuePairs = Set(shoppingList).map{ ($0, false )}
        self.shoppingList = Dictionary(uniqueKeysWithValues: keyValuePairs)
    }

    func addToCart(name: String, quantity: Int, cost: Double) throws {
        let shoppingListNames = shoppingList.keys.map{$0.name}

        guard shoppingListNames.contains(name),
            var shoppingListItem = shoppingList.keys.first(where: {$0.name == name})
            else {
                throw GroceryTripError.itemNotInShoppingList }

        guard shoppingListItem.quantity == quantity else {
            if shoppingListItem.quantity > quantity {
                throw GroceryTripError.itemQuantityFallsShortOfRequiredAmount
            }
            throw GroceryTripError.itemQuantityExceedsRequiredAmount
        }


        shoppingList[shoppingListItem] = true
        shoppingListItem.update(cost: cost)
        cart.append(shoppingListItem)

        if balance < 0.0 { throw GroceryTripError.exceedsBudget }
    }

    func removeFromCart(_ groceryItem: GroceryItem) {
        cart.removeAll(where: {$0 == groceryItem})
        shoppingList[groceryItem] = false
    }

    func checkout() throws -> (shoppingList: [GroceryItem], remainingBudget: Double){
        guard balance > 0.0 else { throw GroceryTripError.exceedsBudget }
        let remainingShoppingList = shoppingList.filter { (shoppingListEntry) -> Bool in
            return !shoppingListEntry.value
        }.keys

        return (Array(remainingShoppingList), balance)
    }

    func update(taxRate: Double) throws {
        self.taxRate = taxRate

        if balance < 0.0 { throw GroceryTripError.exceedsBudget }
    }
}

extension GroceryItem: Hashable {}



