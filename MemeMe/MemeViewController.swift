import UIKit

class MemeViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: UI

    private let defaultTexts: [String: String] = [
        "top": "Top Text",
        "bottom": "Bottom Text"
    ]

    private let defaultTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.boldSystemFont(ofSize: 40.0),
        .strokeColor: UIColor.black,
        .strokeWidth: -1.5,
        .foregroundColor: UIColor.white
    ]

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

    private lazy var topTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.defaultTextAttributes = defaultTextAttributes
        textField.delegate = self
        textField.textAlignment = .center
        textField.text = "Top Text"
        return textField
    }()

    private lazy var bottomTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.defaultTextAttributes = defaultTextAttributes
        textField.delegate = self
        textField.textAlignment = .center
        textField.text = "Bottom Text"
        return textField
    }()

    // MARK: View

    private func addViewHierarchy() {
        view.addSubview(imageView)
        view.addSubview(topTextField)
        view.addSubview(bottomTextField)
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
            topTextField.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 16),
            topTextField.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 24),
            topTextField.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -24)
        ])

        NSLayoutConstraint.activate([
            bottomTextField.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16),
            bottomTextField.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 24),
            bottomTextField.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -24)
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

// MARK: - Text Field Delegate

extension MemeViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let defaultOfTop = defaultTexts["top"],
              let defaultOfBottom = defaultTexts["bottom"] else { return true }

        if textField == topTextField && textField.text == defaultOfTop {
            textField.text = String()
        } else if textField.text == defaultOfBottom {
            textField.text = String()
        }

        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
