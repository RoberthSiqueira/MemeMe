import UIKit

class SentMemeCollectionViewController: UICollectionViewController {

    // MARK: - PROPERTIES

    private let cellIdentifier = "CustomMemeCell"

    var memes: [Meme] {
        let object = UIApplication.shared.delegate
        let appDelegate = object as? AppDelegate
        return appDelegate?.memes ?? []
    }

    // MARK: - UI

    private lazy var addMemeButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openMemeEditor))
        return barButtonItem
    }()

    // MARK: - INIT

    init(collectionViewFlowLayout layout: UICollectionViewFlowLayout) {
        super.init(collectionViewLayout: layout)

        let space: CGFloat = 3.0
        layout.minimumInteritemSpacing = space
        layout.minimumLineSpacing = space
        layout.sectionInset = UIEdgeInsets(top: 0, left: space, bottom: 0, right: space)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LIFE CYCLE METHODS

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        collectionView.register(CustomMemeCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    // MARK: - PRIVATE METHODS

    private func setupNavigationItems() {
        navigationItem.title = "Sent Memes"
        navigationItem.setRightBarButton(addMemeButton, animated: true)
    }

    // MARK: - ACTION

    @objc private func openMemeEditor() {
        let memeVC = MemeViewController()
        navigationController?.pushViewController(memeVC, animated: true)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CustomMemeCollectionCell else {
            return UICollectionViewCell()
        }
        cell.setMeme(memes[indexPath.row])
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memedImage = memes[indexPath.row].memedImage
        let detailVC = MemeDetailViewController(memedImage: memedImage)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension SentMemeCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAt indexPath: IndexPath) -> CGSize {
        let space = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        return CGSize(width: dimension / 2, height: dimension)
    }
}
