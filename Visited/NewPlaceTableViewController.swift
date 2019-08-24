import UIKit
import Cosmos

class NewPlaceTableViewController: UITableViewController {
    
    var selectedPlaceType = PlaceType.Other
    var isImageChanged = false
    var currentPlace: Place!
    var currentRating = 0.0
    
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeTypePicker: UIPickerView!
    @IBOutlet weak var placeLocationField: UITextField!
    @IBOutlet weak var placeNameField: UITextField!
    @IBOutlet weak var ratingCosmosView: CosmosView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: tableView.frame.size.width,
            height: 1))
        
        saveButton.isEnabled = false
        placeNameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        placeTypePicker.delegate = self
        placeTypePicker.dataSource = self
        
        setupEditScreen()
        
        ratingCosmosView.didTouchCosmos = { rating in
            self.currentRating = rating
        }
    }
    
    // MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoLibraryIcon = #imageLiteral(resourceName: "gallery")
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            actionSheet.view.tintColor = .black
            
            
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            
            let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            camera.setValue(cameraIcon, forKey: "image")
            photoLibrary.setValue(photoLibraryIcon, forKey: "image")
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photoLibrary)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier,
            let mapVC = segue.destination as? MapViewController
            else { return }
        
        mapVC.currentSegueIdentifier = identifier
        mapVC.mapViewControllerDelegate = self 
        
        if identifier == "showPlace" {
            mapVC.place.name = placeNameField.text!
            mapVC.place.location = placeLocationField.text!
            mapVC.place.type = PlaceType.allCases[placeTypePicker.selectedRow(inComponent: 0)]
            mapVC.place.imageData = placeImage.image?.pngData()
        }
        
    }
    
    
    func savePlace() {
        
        let image = isImageChanged ? placeImage.image : #imageLiteral(resourceName: "Default place image")
        
        selectedPlaceType = PlaceType.allCases[placeTypePicker.selectedRow(inComponent: 0)]
        
        let newPlace = Place(name: placeNameField.text!,
                             location: placeLocationField.text!,
                             type: selectedPlaceType,
                             imageData: image?.pngData(),
                             rating: ratingCosmosView.rating)
        
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.rating = newPlace.rating
            }
        } else {
            StorageManager.saveObject(newPlace)
        }
    }
    
    private func setupEditScreen() {
        
        guard currentPlace != nil else { return }
        guard let data = currentPlace?.imageData, let image = UIImage(data: data) else { return }
        
        setupNavigationBar()
        isImageChanged = true
        
        placeImage.image = image
        placeImage.contentMode = .scaleAspectFill
        
        placeNameField.text = currentPlace?.name
        placeLocationField.text = currentPlace?.location
        placeTypePicker.selectRow(PlaceType.index(of: currentPlace!.type), inComponent: 0, animated: true)
        
        ratingCosmosView.rating = currentPlace.rating
        
    }
    
    private func setupNavigationBar () {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}
