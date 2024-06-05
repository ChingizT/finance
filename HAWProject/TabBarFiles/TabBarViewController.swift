import UIKit
import FirebaseAuth

class TabBarController: UITabBarController  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setTabBarAppearance()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
    }
    
    @objc func logoutTapped() {
            do {
                try Auth.auth().signOut()
                let loginViewController = LoginViewController()
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = loginViewController
                    UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil)
                }
            } catch let error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
            }
        }
    
    private func generateTabBar() {
    viewControllers = [
        generateVC(viewController: UINavigationController(rootViewController:HomeViewController()), title: "Мой кабинет", image: UIImage(systemName: "macbook.and.iphone")),
    generateVC(viewController: UINavigationController(rootViewController:PoleznoeViewController()), title: "Саморазвитие", image: UIImage(systemName: "book")),
    generateVC(viewController: UINavigationController(rootViewController: MyFinCabViewController()), title: "Мои Финансы", image: UIImage(systemName: "pencil.and.list.clipboard"))
        ]
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) ->
    UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    private func setTabBarAppearance() {
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 14
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
        
        let roundLayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(
            roundedRect: CGRect(
                x: positionOnX,
                y: tabBar.bounds.minY - positionOnY,
                width: width,
                height: height),
            
            cornerRadius: height / 2
            )
        roundLayer.path = bezierPath.cgPath
        
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        tabBar.itemWidth = width / 4
        tabBar.itemPositioning = .centered
        
        roundLayer.fillColor = UIColor.osnovnoyWhite.cgColor
        tabBar.tintColor = .tabBarItemAccent
        tabBar.unselectedItemTintColor = .tabBarItemLight
            
    }
}
