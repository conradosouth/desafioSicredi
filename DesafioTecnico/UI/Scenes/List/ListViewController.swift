import UIKit

class ListViewController: BaseViewController<ListSceneState, ListViewModel> {
    
    private let cell = "cell"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var connectionFailedView: UIView!
    
    override func updateUI(sceneState: ListSceneState?) {
        self.hideLoader()
        if sceneState?.error != nil {
            connectionFailedView.isHidden = false
            self.showErrorAlert(message: "Erro de conexão com o servidor")
        } else {
            connectionFailedView.isHidden = true
            DispatchQueue.main.async {
                self.tableView.alpha = 1
                self.tableView.reloadData()
            }
        }
        
    }
}

// MARK: - Lifecycle

extension ListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readEvents()
        setupUi()
    }
    
}

// MARK: - UITableViewDatasource and Delegate

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let events = viewModel.data?.events else { return 0 }
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cell) as? ListTableViewCell else { fatalError() }
        guard let event = viewModel.getEvent(index: indexPath.row) else { fatalError() }
        cell.setLayout(event: event)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let event = viewModel.getEvent(index: indexPath.row) else { fatalError() }
        goToDetail(event: event)
        
    }
    
}

// MARK: - Functions

extension ListViewController {
    
    func setupUi() {
        tableView.alpha = 0
        navigationItem.title = "Eventos"
    }
    
    func readEvents() {
        self.showLoader()
        viewModel.readEvents()
    }
    
    func goToDetail(event: Event) {
        
        guard let destination: DetailViewController = router?.destination(for: .Detail) else { return }
        
        destination.eventId = event.id
        
        navigationController?.pushViewController(destination, animated: true)
        
    }
    
}

// MARK: - IBActions

extension ListViewController {
    
    @IBAction func tryAgainPressed(_ sender: Any) {
        readEvents()
    }
    
}
