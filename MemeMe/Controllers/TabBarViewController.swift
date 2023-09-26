import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    // MARK: UI

    private lazy var tableModeTabBarItem: UITabBarItem = {
        let image = UIImage(imageLiteralResourceName: "table")
        let tabBarItem = UITabBarItem(title: nil, image: image, tag: 0)
        return tabBarItem
    }()

    private lazy var collectionModeTabBarItem: UITabBarItem = {
        let image = UIImage(imageLiteralResourceName: "collection")
        let tabBarItem = UITabBarItem(title: nil, image: image, tag: 0)
        return tabBarItem
    }()

    // MARK: LIFE CYCLE METHODS

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
    }

    // MARK: PRIVATE METHODS

    private func setupViewControllers() {
        let memeVC = MemeViewController()
        let memeCollectionVC = MemeCollectionViewController()

        let navigationFromMemeVC = UINavigationController(rootViewController: memeVC)
        let navigationFromMemeCollectionVC = UINavigationController(rootViewController: memeCollectionVC)

        navigationFromMemeVC.tabBarItem = tableModeTabBarItem
        navigationFromMemeCollectionVC.tabBarItem = collectionModeTabBarItem

        let viewControllers = [navigationFromMemeVC, navigationFromMemeCollectionVC]

        viewControllers.forEach { navigationVC in
            navigationVC.navigationBar.topItem?.title = "Sent Memes"
        }
        
        setViewControllers(viewControllers, animated: true)
        selectedViewController = viewControllers[0]
    }
}
