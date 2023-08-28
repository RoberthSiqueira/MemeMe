import UIKit

class MemeViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: UI

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        return imageView
    }()

    private lazy var pickAlbumBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Library", image: nil, target: self, action: #selector(pickAnImageFromAlbum))
        return barButtonItem
    }()

    private lazy var pickCameraBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Camera", image: nil, target: self, action: #selector(pickAnImageFromCamera))
        return barButtonItem
    }()

    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: .zero)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.setItems([pickAlbumBarButton, pickCameraBarButton], animated: true)
        return toolBar
    }()

    // MARK: View

    private func addViewHierarchy() {
        view.addSubview(imageView)
        view.addSubview(toolBar)

        setupConstraints()
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: toolBar.topAnchor)
        ])

        NSLayoutConstraint.activate([
            toolBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            toolBar.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }

    // MARK: Instance Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViewHierarchy()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pickCameraBarButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    // MARK: Actions

    @objc private func pickAnImageFromAlbum() {
        let pickerViewController = UIImagePickerController()
        pickerViewController.delegate = self
        pickerViewController.sourceType = .photoLibrary
        present(pickerViewController, animated: true)
    }

    @objc private func pickAnImageFromCamera() {
        let pickerViewController = UIImagePickerController()
        pickerViewController.delegate = self
        pickerViewController.sourceType = .camera
        present(pickerViewController, animated: true)
    }
}

// MARK: - Image Picker Delegate

extension MemeViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        }
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

