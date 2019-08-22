import UIKit
import Cosmos

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placeImage: UIImageView! {
        didSet {
            placeImage.layer.cornerRadius = placeImage.frame.size.height / 2
            placeImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeLocationLabel: UILabel!
    @IBOutlet weak var placeTypeLabel: UILabel!
    @IBOutlet weak var placeRatingView: CosmosView! {
        didSet {
            placeRatingView.settings.updateOnTouch = false
        }
    }
    
    

}
