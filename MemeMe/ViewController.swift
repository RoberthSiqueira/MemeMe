import UIKit

class ViewController: UIViewController {

    // MARK: UI

    private lazy var pickBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Pick", image: nil, target: self, action: #selector(pickAnImage))
        return barButtonItem
    }()

    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: .zero)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.setItems([pickBarButton], animated: true)
        return toolBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViewHierarchy()
    }

    // MARK: View

    private func addViewHierarchy() {
        view.addSubview(toolBar)

        setupConstraints()
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            toolBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            toolBar.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }

    // MARK: Actions

    @objc private func pickAnImage() {
        let pickerViewController = UIImagePickerController()
        present(pickerViewController, animated: true)
    }
}

