import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    let mapManager = MapManager()
    var mapViewControllerDelegate: MapViewControllerDelegate?
    var place = Place()
    
    let annotationIdentifier = "annotationIdentifier"
    var currentSegueIdentifier = ""
    
    var previousUserLocation: CLLocation? {
        didSet {
            mapManager.startTrackingUserLocation(for: mapView,
                                                 and: previousUserLocation) { (currentLocation) in
                                                    self.previousUserLocation = currentLocation
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                        self.mapManager.showUserLocation(mapView: self.mapView)
                                                    }
            }
        }
    }
    
    var isNavigatorActive = false

    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var userLocationButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var mapPinImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupMapView()
        
        buttonsStackView.addBackground(color: UIColor(red: 1, green: 1, blue: 1, alpha: 0.8),
                                    cornerRadius: 10)
        addressLabel.text = ""
    }
    
    @IBAction func centerViewInUserLocation() {
       mapManager.showUserLocation(mapView: mapView)
    }
    
    
    @IBAction func closeMapVC() {
        dismiss(animated: true)
    }
    
    
    @IBAction func goButtonPressed() {
        
        
        
        isNavigatorActive.toggle()
        userLocationButton.isEnabled.toggle()
        if isNavigatorActive {
            goButton.setImage(#imageLiteral(resourceName: "stop"), for: .normal)
            mapManager.getDirection(mapView: mapView) { (location) in
                self.previousUserLocation = location
            }
        } else {
            goButton.setImage(#imageLiteral(resourceName: "getDirection"), for: .normal)
            mapManager.resetMapView(withNew: nil, mapView: mapView)
        }
    }
    
    
    @IBAction func doneButtonPressed() {
    
        mapViewControllerDelegate?.getAddress(addressLabel.text)
        dismiss(animated: true)
        
    }

    
    private func setupMapView () {
        
        goButton.isHidden = true
        
        mapManager.checkLocationServices(mapView: mapView, segueIdentifier: currentSegueIdentifier) {
             mapManager.locationManager.delegate = self
        }
        
        if currentSegueIdentifier == "showPlace" {
            mapManager.setupPlacemark(place: place, mapView: mapView)
            mapPinImage.isHidden = true
            addressLabel.isHidden = true
            doneButton.isHidden = true
            goButton.isHidden = false
        }
    }
    
}
