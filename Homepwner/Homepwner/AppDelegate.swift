import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)


        let ivc = ItemsViewController()
        let navCtrlr = UINavigationController(rootViewController: ivc)
        window.rootViewController = navCtrlr
        
        window.backgroundColor = UIColor.whiteColor()
        window.makeKeyAndVisible()
        return true
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        let success = BNRItemStore.sharedStore.saveChanges()
        if (success){
            println("Saved all items")
        } else {
            println("Could not save any of the BNRItems")
        }
    }
}

