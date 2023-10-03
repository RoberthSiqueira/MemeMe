import UIKit

class CustomMemeTableCell: UITableViewCell {

    // MARK: - PROPERTIES

    private var meme: Meme? {
        didSet {
            memeImageView.image = meme?.memedImage
            memeLabel.text = """
                            \(meme?.topText ?? "") "/" \(meme?.bottomText ?? "")
                            """
        }
    }

    // MARK: - INIT

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(memeImageView)
        contentView.addSubview(memeLabel)
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - UI

    private lazy var imageContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var memeImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var memeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()

    // MARK: - PRIVATE METHODS

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            memeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            memeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            memeImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.33),
            memeImageView.heightAnchor.constraint(equalToConstant: 96),
            memeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            memeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            memeLabel.leadingAnchor.constraint(equalTo: memeImageView.trailingAnchor, constant: 16),
            memeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            memeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}

extension CustomMemeTableCell: CustomMemeCellsDelegate {
    func setMeme(_ meme: Meme) {
        self.meme = meme
    }
}
