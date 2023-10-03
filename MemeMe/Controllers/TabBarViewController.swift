import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    // MARK: UI

    private lazy var addMemeButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openMemeEditor))
        return barButtonItem
    }()

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
        setupNavigationItems()
        setupViewControllers()
    }

    // MARK: PRIVATE METHODS

    private func setupNavigationItems() {
        navigationItem.title = "Sent Memes"
        navigationItem.setRightBarButton(addMemeButton, animated: true)
    }

    private func setupViewControllers() {
        let sentMemeTableVC = SentMemeTableViewController()
        let sentMemeCollectionVC = SentMemeCollectionViewController(collectionViewFlowLayout: UICollectionViewFlowLayout())

        let navigationFromMemeTable = UINavigationController(rootViewController: sentMemeTableVC)
        let navigationFromMemeCollection = UINavigationController(rootViewController: sentMemeCollectionVC)

        navigationFromMemeTable.tabBarItem = tableModeTabBarItem
        navigationFromMemeCollection.tabBarItem = collectionModeTabBarItem

        let navigationControllers = [navigationFromMemeTable, navigationFromMemeCollection]
        
        setViewControllers(navigationControllers, animated: true)
        selectedViewController = navigationControllers[0]
    }

    // MARK: - ACTION

    @objc private func openMemeEditor() {
        let memeVC = MemeViewController()
        navigationController?.pushViewController(memeVC, animated: true)
    }
}
