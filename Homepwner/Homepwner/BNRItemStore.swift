//
//  BNRItemStore.swift
//  Homepwner
//
//  Created by John on 9/14/14.
//  Copyright (c) 2014 In Your Dreams Software. All rights reserved.
//

import UIKit

private let _BNRItemStoreSharedStore = BNRItemStore()

//Use this by calling BNRItemStore.sharedStore to get the Singleton Object. It will be instantiated lazily the first time it is called.

class BNRItemStore: NSObject {

    //class variable with only a computed getter returning the private var
    class var sharedStore: BNRItemStore {
            return _BNRItemStoreSharedStore
    }

    private var allItems = [BNRItem]()
    
    override init(){
        super.init()
    }

    func createItem() -> BNRItem{
        let p = BNRItem.randomItem()
        allItems.append(p)
        return p
    }

    func getAllItems() -> [BNRItem]{
        return allItems
    }
    
    func getUnder50DollarItems() -> [BNRItem] {
            return allItems.filter{ $0.valueInDollars <= 50 }
    }
    func getOver50DollarItems() -> [BNRItem] {
            return allItems.filter{ $0.valueInDollars > 50 }
    }

}



