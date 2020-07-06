import UIKit
import MapKit

class DetailViewController: BaseViewController<DetailSceneState, DetailViewModel> {
    
    public var eventId: String?
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var confirmedPeopleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var checkinButton: UIButton!
    
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    override func updateUI(sceneState: DetailSceneState?) {
        self.hideLoader()
        if sceneState?.error != nil {
            contentView.isHidden = true
            if let checkedIn = sceneState?.checkedIn {
                if !checkedIn {
                    self.showErrorAlert(message: "Erro ao realizar check-in!")
                }
            } else {
                self.showErrorAlert(message: "Erro ao se comunicar com o servidor!")
            }
        } else {
            contentView.isHidden = false
            if let event = sceneState?.event {
                self.setLayout(event: event)
            }
            if let checkedIn = sceneState?.checkedIn {
                if checkedIn {
                    setCheckin(event: sceneState?.event)
                } else {
                    self.showErrorAlert(message: "Erro ao realizar check-in!")
                }
            }
        }
    }
}

// MARK: - Lifecycle

extension DetailViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUi()
        readEvent()

    }

}

// MARK: - Functions

extension DetailViewController {
    
    func setupUi() {
        
        contentView.isHidden = true
        navigationItem.title = "Detalhes"
        let shareButton: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem:.action, target: self, action: #selector(sharePressed))
        self.navigationItem.rightBarButtonItem = shareButton
        
    }
    
    func setCheckin(event: Event?) {
        
        checkinButton.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.6309129902, blue: 0.3490196078, alpha: 1)
        checkinButton.setTitle("Você fez check-in", for: .normal)
        checkinButton.isUserInteractionEnabled = false
        if let people = event?.people?.people {
            let counter = people.count
            if counter > 0 {
                var howMuchPeople = "pessoa"
                if counter > 1 {
                   howMuchPeople = "pessoas"
                }
                confirmedPeopleLabel.text = "Você e mais " + String(counter) + " \(howMuchPeople) confirmaram"
            }
        }

    }
    
    func setLayout(event: Event) {
        if let longitude = event.longitude {
            if let latitude = event.latitude {
                setMap(latitude: latitude, longitude: longitude, title: "Evento")
            }
        }
        
        titleLabel.text = event.title
        
        if let ts = event.date {
           let date = Date(timeIntervalSince1970: TimeInterval(ts/1000))

           let dayTimePeriodFormatter = DateFormatter()
           dayTimePeriodFormatter.dateFormat = "dd/MM/YYYY HH:MM"

           let dateString = dayTimePeriodFormatter.string(from: date)
           dateLabel.text = dateString
        }
        if let price = event.price {
            priceLabel.text = "R$ " + String(price)
        }
        if let people = event.people?.people {
           let count = people.count
           if count == 0 {
               confirmedPeopleLabel.isHidden = true
           } else if count == 1 {
               confirmedPeopleLabel.text = "1 pessoa confirmou"
           } else {
               confirmedPeopleLabel.text = String(count) + " pessoas confirmaram"
           }
        }
        if let description = event.description {
            descriptionLabel.text = description
        }
        
    }
    
    func readEvent() {
        if let id = eventId {
            self.showLoader()
            viewModel.readEvent(eventId: id)
        }
    }
    
    func doCheckin() {
        if let id = eventId {
            self.showLoader()
            viewModel.checkin(eventId: id)
        }
    }
    
    func setMap(latitude: Double, longitude: Double, title: String) {
        
        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
        centerMapOnLocation(location: initialLocation)
        let artwork = Artwork(title: title,
                              coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        mapView.addAnnotation(artwork)
    }
    
   
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 300
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

// MARK: - IBActions

extension DetailViewController {
    
    @IBAction private func checkinPressed(_ sender: Any) {
         doCheckin()
     }
    
    @objc
    func sharePressed() {
        guard let event = viewModel.data?.event else { return }
        guard let timestamp = event.date else { return }
        guard let title = event.title else { return }
        
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp/1000))

        let dayPeriodFormatter = DateFormatter()
        dayPeriodFormatter.dateFormat = "dd/MM/YYYY"

        let timePeriodFormatter = DateFormatter()
        timePeriodFormatter.dateFormat = "HH:MM"
        
        let day = dayPeriodFormatter.string(from: date)
        let time = timePeriodFormatter.string(from: date)
        let text = "Eu vou no evento: " + title + " que vai acontecer no dia " + day + " às " + time

        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,
            ]

        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}
 
