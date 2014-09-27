//
//  BNRItem.swift
//  RandomPossessions
//
//  Created by John Regner on 7/28/14.
//  Copyright (c) 2014 In Your Dreams Software. All rights reserved.
//

import Foundation

class BNRItem : NSObject{
    var itemName: String
    var serialNumber: String
    var valueInDollars: Int
    var dateCreated: NSDate

    override var description: String{
    get{
        return "\(itemName) (\(serialNumber)): Worth $\(valueInDollars), recorded on \(dateCreated)"
    }
    }
    init(WithItemName name: String, valueInDollars: Int, serialNumber: String ){
        self.itemName = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreated = NSDate()
        super.init()
    }
    convenience init(WithItemName name: String, serialNumber: String){
        self.init(WithItemName: name, valueInDollars: 0, serialNumber: serialNumber)
    }

    class func randomItem () -> BNRItem {
        let randomAdjectiveList = ["Fluffy", "Rusty", "Shiny"]
        let randomNounList = ["Bear", "Spork", "Mac"]

        let adjectiveIndex = randomNumberLessThan(randomAdjectiveList.count)
        let nounIndex = randomNumberLessThan(randomNounList.count)
        let randomName = randomAdjectiveList[adjectiveIndex] + randomNounList[nounIndex]

        let randomValue = randomNumberLessThan(100)

        let numbers = arrayOfZeroThroughNine()
        let chars = arrayOfAThroughZ()

        let randomSerialNumber =
        "\(numbers[randomNumberLessThan(10)])\(chars[randomNumberLessThan(26)])\(numbers[randomNumberLessThan(10)])\(chars[randomNumberLessThan(26)])\(numbers[randomNumberLessThan(10)])"
        return BNRItem(WithItemName: randomName, valueInDollars: randomValue, serialNumber: randomSerialNumber)
    }

}

func randomNumberLessThan(maxNumber: Int) -> Int {
    return Int(arc4random()) % maxNumber
}

func arrayOfZeroThroughNine() -> [String] {
    var numbers = [String]()
    for num in 0...9 {
        numbers.append(String(num))
    }
    return numbers
}

func arrayOfAThroughZ() -> [String] {
    var chars = [String]()
    for char in 0x61...0x7A { //ascii 'a' is code point 0x61 => 97, 'z' is 0x7A
        chars.append(String(UnicodeScalar(char)))
    }
    return chars
}

class BNRContainer : BNRItem {
    //properly written can contain instances of BNRContainer
    var subItems = [BNRItem]()
    var collectionValue: Int { //calculated property must be declared as var
        var sum: Int = 0
        for item in subItems {
            if let container = item as? BNRContainer {
                sum += container.collectionValue
                sum += container.valueInDollars
            }
            else { //else item is just a BNRItem
            sum += item.valueInDollars
            }
        }
        return sum
    }
    
    init(WithContainerName name: String){
        super.init(WithItemName: name, valueInDollars: 0, serialNumber: "")
    }

    func addItem(item:BNRItem) -> (){
        subItems.append(item)
    }

    func description() -> String {
        //returns the container name and value in dollars, and list of items
        var items: String = ""
        for item in subItems {
            items += item.itemName
            items += " "
        }
        return "Container: \(itemName)\nValue: \(collectionValue)\nWith Items: \(items)"
    }
}
