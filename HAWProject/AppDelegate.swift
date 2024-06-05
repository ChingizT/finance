import UIKit
import FirebaseAuth
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let tabBarController = TabBarController()
        let loginViewController = LoginViewController()
        
        if Auth.auth().currentUser == nil {
            window?.rootViewController = loginViewController
        } else {
            window?.rootViewController = tabBarController
        }
        
        window?.makeKeyAndVisible()
        
        return true
    }
}

