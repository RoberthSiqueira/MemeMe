import UIKit

class CustomMemeCollectionCell: UICollectionViewCell {

    // MARK: - PROPERTIES

    private var meme: Meme? {
        didSet {
            memeImageView.image = meme?.memedImage
        }
    }

    // MARK: - INIT

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(memeImageView)
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI

    private lazy var memeImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    // MARK: - PRIVATE METHODS

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            memeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            memeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            memeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            memeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension CustomMemeCollectionCell: CustomMemeCellsDelegate {
    func setMeme(_ meme: Meme) {
        self.meme = meme
    }
}
