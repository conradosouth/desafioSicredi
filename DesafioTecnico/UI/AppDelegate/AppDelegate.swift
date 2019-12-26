import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {
    
    /// Window for content
    var contentWindow: UIWindow?
    
    /// Window for the loader
    var loaderWindow: UIWindow?
    
    /// Loader scene
    var loaderScene: LoaderViewController?
    
    /// Router of the navigation
    let router: RouterProtocol = Router()
}

// MARK: - UIApplicationDelegate
extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        
        contentWindow = UIWindow(frame: UIScreen.main.bounds)
        contentWindow?.rootViewController = router.destination(for: .List)
        contentWindow?.makeKeyAndVisible()
        
        loaderWindow = UIWindow(frame: UIScreen.main.bounds)
        loaderScene = router.destination(for: .Loader)
        loaderWindow?.rootViewController = loaderScene
        
        return true
    }
}

// MARK: - Loader
extension AppDelegate {
    
    func showLoader() {
        loaderWindow?.isHidden = false
        loaderScene?.startLoader()
    }
    
    func hideLoader() {
        loaderScene?.stopLoader()
        loaderWindow?.isHidden = true
    }
}
