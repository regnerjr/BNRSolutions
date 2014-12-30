import UIKit
import XCTest

class HomepwnerTests: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
 
  // MARK - Test Initializers
  
  func testBNRItemEmptyInitializer() {
    let item = BNRItem()
    XCTAssert(item.itemName == "", "name is empty")
    XCTAssert(item.serialNumber == "", "serial Number is empty")
    XCTAssert(item.valueInDollars == 0, "value is zero")
    XCTAssert(item.imageKey == nil, "image key is empty")
    XCTAssert(item.thumbnail == nil, "thumbnail is empty")
    XCTAssert(item.thumbnailData == nil, "thumbnailData is empty")
  }

  func testBNRItemInitWitNameSerialNumber() {
    let item = BNRItem(WithItemName: "someName", serialNumber: "someSerialNumber")
    XCTAssert(item.itemName == "someName", "name is set properly")
    XCTAssert(item.serialNumber == "someSerialNumber", "serial Number is set properly")
    XCTAssert(item.valueInDollars == 0, "value is zero")
    XCTAssert(item.imageKey == nil, "image key is empty")
    XCTAssert(item.thumbnail == nil, "thumbnail is empty")
    XCTAssert(item.thumbnailData == nil, "thumbnailData is empty")
  }
  
  func testBNRItemInitWitNameValueInDollarsSerialNumber() {
    let item = BNRItem(WithItemName: "someName", valueInDollars: 10, serialNumber: "someSerialNumber")
    XCTAssert(item.itemName == "someName", "name is set properly")
    XCTAssert(item.serialNumber == "someSerialNumber", "serial Number is set properly")
    XCTAssert(item.valueInDollars == 10, "value is ten")
    XCTAssert(item.imageKey == nil, "image key is empty")
    XCTAssert(item.thumbnail == nil, "thumbnail is empty")
    XCTAssert(item.thumbnailData == nil, "thumbnailData is empty")
  }

  // MARK - Properties
  func testDescription(){
    let item = BNRItem(WithItemName: "someName", valueInDollars: 10, serialNumber: "someSerialNumber")
    XCTAssert(item.description == "someName (someSerialNumber): Worth $10, recorded on \(item.dateCreated)", "description works correctly")
  }
  
  
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measureBlock() {
        // Put the code you want to measure the time of here.
    }
  }
    
}
