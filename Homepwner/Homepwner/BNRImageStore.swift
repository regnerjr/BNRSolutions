//
//  BNRImageStore.swift
//  Homepwner
//
//  Created by John on 10/25/14.
//  Copyright (c) 2014 In Your Dreams Software. All rights reserved.
//

import UIKit

private let _BNRImageStoreSharedStore = BNRImageStore()

//Use this by calling BNRItemStore.sharedStore to get the Singleton Object. It will be instantiated lazily the first time it is called.

class BNRImageStore: NSObject {

    private var imageDictionary = [String:UIImage]()
    
    override init(){
        super.init()
    }
    
    //class variable with only a computed getter returning the private var
    class var sharedStore: BNRImageStore {
        return _BNRImageStoreSharedStore
    }

    //in an effort for later expansion and test, these should all return something.
    func setImage(image:UIImage, forKey key: String) -> Dictionary<String,UIImage>{
        imageDictionary[key] = image
        return imageDictionary
    }
    
    func imageForKey(key: String) -> UIImage? {
        return imageDictionary[key]
    }
    
    func deleteImageForKey(key: String) -> Dictionary<String,UIImage>{
        imageDictionary.removeValueForKey(key)
        return imageDictionary
    }

}
