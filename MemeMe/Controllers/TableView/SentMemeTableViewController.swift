import UIKit

class SentMemeTableViewController: UITableViewController {

    // MARK: - PROPERTIES

    private let cellIdentifier = "CustomMemeTableCell"

    var memes: [Meme] {
        let object = UIApplication.shared.delegate
        let appDelegate = object as? AppDelegate
        return appDelegate?.memes ?? []
    }

    // MARK: - LIFE CYCLE METHODS

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CustomMemeTableCell.self, forCellReuseIdentifier: cellIdentifier)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? CustomMemeTableCell else {
            return UITableViewCell()
        }
        cell.setMeme(memes[indexPath.row])
        return cell
    }
}
