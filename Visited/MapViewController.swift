import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var userLocationButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var mapPinImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var goButton: UIButton! {
        didSet {
            goButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
            goButton.layer.cornerRadius = 10
        }
    }
    
    var mapViewControllerDelegate: MapViewControllerDelegate?
    var place = Place()
    let annotationIdentifier = "annotationIdentifier"
    let locationManager = CLLocationManager()
    let regionInMeters = 1000.0
    var currentSegueIdentifier = ""
    var placeCoordinate: CLLocationCoordinate2D?
    var previousUserLocation: CLLocation? {
        didSet {
            startTrackingUserLocation()
        }
    }
    var directionsArray: [MKDirections] = []
    var isNavigatorActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupMapView()
        checkLocationServices()
        
        buttonsStackView.addBackground(color: UIColor(red: 1, green: 1, blue: 1, alpha: 0.8),
                                    cornerRadius: 10)
        addressLabel.text = ""
    }
    
    @IBAction func centerViewInUserLocation() {
        
        showUserLocation()
    }
    
    
    @IBAction func closeMapVC() {
        dismiss(animated: true)
    }
    
    
    @IBAction func goButtonPressed() {
        isNavigatorActive.toggle()
        userLocationButton.isEnabled.toggle()
        if isNavigatorActive {
            goButton.setImage(#imageLiteral(resourceName: "stop"), for: .normal)
            getDirection()
        } else {
            goButton.setImage(#imageLiteral(resourceName: "getDirection2"), for: .normal)
            resetMapView(withNew: nil)
        }
    }
    
    @IBAction func doneButtonPressed() {
    
        mapViewControllerDelegate?.getAddress(addressLabel.text)
        dismiss(animated: true)
        
    }
    
    
    private func getDirection() {
        
        guard let location = locationManager.location?.coordinate else {
                    showAlert(title: "Error", message: "Current location is not found")
                    return
        }
        
        locationManager.startUpdatingLocation()
        
            previousUserLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            
            guard let request = createDirectionRequest(from: location) else {
                showAlert(title: "Error", message: "Destination is not found")
                return
            }
            
            let direction = MKDirections(request: request)
            resetMapView(withNew: direction)
            
            direction.calculate { (response, error) in
                
                if let error = error {
                    print(error)
                    return
                }
                
                guard let response = response else {
                    self.showAlert(title: "Error", message: "Direction is not avaliable")
                    return
                }
                
                for route in response.routes {
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
            }
            
    }
    
    private func createDirectionRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        
        guard let destinationCoordinate = placeCoordinate else { return nil }
        let startLocation = MKPlacemark(coordinate: coordinate)
        let finishLocation = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startLocation)
        request.destination = MKMapItem(placemark: finishLocation)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    
    private func setupPlacemark() {
        
        guard let location = place.location else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = self.place.name
            annotation.subtitle = self.place.type.rawValue
            
            guard let placemarkLocation = placemark?.location else { return }
            
            annotation.coordinate = placemarkLocation.coordinate
            self.placeCoordinate = placemarkLocation.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
            
        }
    }
    
    private func checkLocationServices() {
        
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Location Services are disabled",
                               message: "Enable services in Settings - Privacy - Location Services - turn ON")
            }
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    internal func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if currentSegueIdentifier == "getAddress" { showUserLocation() }
            break
        case .denied:
            self.showAlert(title: "Your location is not avaliable",
                      message: "Give permission in Settings - Visited - Location")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        @unknown default:
            print("New case is avaliable")
            break
        }
    }
    
    private func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        present(alert,animated: true)
    }
    
    internal func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    private func startTrackingUserLocation() {
        
        guard let previousUserLocation = previousUserLocation else { return }
        let center = getCenterLocation(for: mapView)
        guard center.distance(from: previousUserLocation) > 50 else { return }
        self.previousUserLocation = center
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showUserLocation()
        }
    }
    
    internal func showUserLocation() {
        
        if let location = locationManager.location?.coordinate {
            
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            
            mapView.setRegion(region, animated: true)
            
        }
    }
    
    private func setupMapView () {
        
        goButton.isHidden = true
        
        if currentSegueIdentifier == "showPlace" {
            setupPlacemark()
            mapPinImage.isHidden = true
            addressLabel.isHidden = true
            doneButton.isHidden = true
            goButton.isHidden = false
        }
    }
    
    private func resetMapView(withNew direction: MKDirections?) {
        
        mapView.removeOverlays(mapView.overlays)
        
        if let direction = direction {
            directionsArray.append(direction)
            let _ = directionsArray.map { $0.cancel()
            directionsArray.removeAll()
                
            }
        }
    }
    
}
