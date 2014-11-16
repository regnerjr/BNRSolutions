import UIKit
import MapKit

class BNRMapPoint: NSObject, MKAnnotation, NSCoding{

  var title: String
  let coordinate: CLLocationCoordinate2D
  let subtitle: String

  init(title: String, coordinate: CLLocationCoordinate2D){
    self.title = title
    self.coordinate = coordinate
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    let whenTagged: NSDate = NSDate()
    let formattedDate = formatter.stringFromDate(whenTagged)
    subtitle = formattedDate
    super.init()
  }
    
  convenience override init() {
    let home: String = "Home Town"
    let loc: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 43.07, longitude: -89.32)
    self.init(title: home, coordinate: loc)
  }

  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(title, forKey: "title")
    aCoder.encodeObject(coordinate.latitude, forKey: "latitude")
    aCoder.encodeObject(coordinate.longitude, forKey: "longitude")
    aCoder.encodeObject(subtitle, forKey: "subtitle")
  }

  required init(coder aDecoder: NSCoder) {
    title = aDecoder.decodeObjectForKey("title") as String
    let lat = aDecoder.decodeObjectForKey("latitude") as Double
    let long = aDecoder.decodeObjectForKey("longitude") as Double
    coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    subtitle = aDecoder.decodeObjectForKey("subtitle") as String
    super.init()
  }
}
