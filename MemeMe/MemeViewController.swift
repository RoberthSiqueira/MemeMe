import UIKit

class MemeViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: UI

    private let defaultTexts: [String: String] = [
        "top": "Top Text",
        "bottom": "Bottom Text"
    ]

    private let defaultTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "Impact", size: 40.0) ?? UIFont.boldSystemFont(ofSize: 40.0),
        .strokeColor: UIColor.black,
        .strokeWidth: -1.5,
        .foregroundColor: UIColor.white
    ]

    private lazy var shareButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Share", image: nil, target: self, action: #selector(share))
        barButtonItem.isEnabled = imageView.image != nil
        return barButtonItem
    }()

    private lazy var saveButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Save", image: nil, target: self, action: #selector(save))
        return barButtonItem
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
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
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace, pickAlbumBarButton, flexibleSpace, pickCameraBarButton, flexibleSpace], animated: true)
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
        navigationItem.setLeftBarButton(shareButton, animated: true)
        navigationItem.setRightBarButton(saveButton, animated: true)
        addViewHierarchy()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pickCameraBarButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotification()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotification()
    }

    // MARK: Private Methods

    private func subscribeToKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func unsubscribeToKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        guard let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return .zero }
        return keyboardSize.height
    }

    private func generateMemedImage() -> UIImage {
        showBars(false)

        let _ = UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()

        showBars(true)

        return memedImage
    }

    private func showBars(_ show: Bool) {
        navigationController?.navigationBar.isHidden = !show
        toolBar.isHidden = !show
    }

    // MARK: Actions

    @objc func keyboardWillAppear(_ notification: Notification) {
        view.frame.origin.y = -getKeyboardHeight(notification)
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = .zero
    }

    @objc private func share() {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage, "Meme"], applicationActivities: nil)
        present(activityViewController, animated: true)
        activityViewController.completionWithItemsHandler = { [weak self] activity, success, items, error in
            if success {
                self?.save()
            }
        }
    }

    @objc private func save() {
        let meme = Meme(topText: topTextField.text ?? String(),
                        bottomText: bottomTextField.text ?? String(),
                        originalImage: imageView.image ?? UIImage(),
                        memedImage: generateMemedImage())
    }

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
            shareButton.isEnabled = true
        }
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
