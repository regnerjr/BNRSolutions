import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        //Set the ViewController to your custom class
        let lvc = ListViewController(style: UITableViewStyle.Plain)
        let nav = UINavigationController(rootViewController: lvc)
        window?.rootViewController = nav
        window?.backgroundColor = UIColor.whiteColor()
        window?.makeKeyAndVisible()
        return true
    }
}

