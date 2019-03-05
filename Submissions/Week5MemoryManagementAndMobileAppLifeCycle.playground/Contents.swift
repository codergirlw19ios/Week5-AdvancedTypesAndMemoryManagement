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

do {
    let printerResponse = try send(job: 1040, toPrinter: "Never Has Toner")
    print(printerResponse)
} catch {
    print(error)
}

//: 2.) Add code to throw an error inside the `do` block. Add an error so that the error is handled by the first `catch` block. Add more errors to trigger the second and third blocks.

do {
    let printerResponse = try send(job: 1440, toPrinter: "Gutenberg")
    throw PrinterError.onFire
    print(printerResponse)
} catch PrinterError.onFire {
    print("I'll just put this over here, with the rest of the fire.")
} catch let printerError as PrinterError {
    print("Printer error: \(printerError).")
} catch {
    print(error)
}
