import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var segmented: UISegmentedControl!

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configure Location Manager
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50.0
        locationManager.delegate = self

        map.showsUserLocation = true
        map.mapType = .Satellite

        segmented.selectedSegmentIndex = 1
    }

    @IBAction func setMapType(sender: AnyObject) {
        let index: Int = sender.selectedSegmentIndex
        switch index {
        case 0:
            map.mapType = .Standard
        case 1:
            map.mapType = .Satellite
        case 2:
            map.mapType = .Hybrid
        default:
            map.mapType = .Standard
            segmented.selectedSegmentIndex = 0
        }
    }

    func findLocation(){
        locationManager.startUpdatingLocation()
        activity.startAnimating()
        textField.hidden = true
    }

    func foundLocation(loc: CLLocation){
        let coord: CLLocationCoordinate2D = loc.coordinate
        let mapPoint = BNRMapPoint(title: textField.text, coordinate: coord)
        map.addAnnotation(mapPoint)

        let region = MKCoordinateRegionMakeWithDistance(coord, 250, 250)
        map.setRegion(region, animated: true)

        textField.text = ""
        activity.stopAnimating()
        textField.hidden = false
        locationManager.stopUpdatingLocation()
    }

    ///MARK: CLLocationManager Delegate Methods
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {

        var t = locations[0].timestamp?.timeIntervalSinceNow
        if t == nil { //if no time interval then just quit
            return
        }
        let time_interval = t!
        if (time_interval < -180) {
            //this is cached data quit
            return
        }
        println("number of locations \(locations.count)")
        for index in 0..<locations.count {
            self.foundLocation(locations[index] as CLLocation)
            println("\(locations[index] as CLLocation)")
        }
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Could not find location: \(error)")
    }

    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        println("Heading: \(newHeading)")
    }

    ///MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 250, 250)
        mapView.setRegion(region, animated: true)
    }

    ///MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.findLocation()
        textField.resignFirstResponder()
        return true
    }
}
