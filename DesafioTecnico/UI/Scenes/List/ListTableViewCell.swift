import UIKit
import Kingfisher

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var thumbImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var confirmedPeopleLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
}

// MARK: - Lifecycle

extension ListTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

// MARK: - Functions

extension ListTableViewCell {

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLayout(event: Event) {
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
        titleLabel.text = event.title
        if let thumb = event.image {
            let url = URL(string: thumb)
            thumbImage.kf.setImage(with: url) { result in
                UIView.animate(withDuration: 0.5, animations: {
                    self.thumbImage.alpha = 1.0
                })
                
                switch result {
                case .success:
                    print("Image set")
                case .failure:
                    self.thumbImage.image = #imageLiteral(resourceName: "placeholder-img")
                }
                
            }
        } else {
            self.thumbImage.image = #imageLiteral(resourceName: "placeholder-img")
        }
    }

}
