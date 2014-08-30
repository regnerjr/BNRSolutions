//
//  main.swift
//  RandomPossessions
//
//  Created by John Regner on 7/28/14.
//  Copyright (c) 2014 In Your Dreams Software. All rights reserved.
//

import Foundation


var items:[BNRItem] = Array()//declare mutable array of strings


for i in 0..<10{
    var p = BNRItem.randomItem()
    items += p
}

var outerCollection = BNRContainer(WithContainerName: "OuterStuff")
var innerCollection = BNRContainer(WithContainerName: "InnerStuff")


for i in items {
    println("\(i.itemName): $\(i.valueInDollars)")
    outerCollection.addItem(i)
    innerCollection.addItem(i)
}


println(innerCollection.description)
println(outerCollection.description)

outerCollection.addItem(innerCollection)
println(outerCollection.description)


println(outerCollection.valueInDollars)
outerCollection.valueInDollars = 1000
println(outerCollection.valueInDollars)
