import UIKit

class NewPlaceTableViewController: UITableViewController {
    
//    var selectedPlaceType: PlaceType = .Other
    var selectedPlaceType = PlaceType.Other.rawValue

    var isImageChanged = false
    
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeTypePicker: UIPickerView!
    @IBOutlet weak var placeLocationField: UITextField!
    @IBOutlet weak var placeNameField: UITextField!
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        saveButton.isEnabled = false
        placeNameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    
        placeTypePicker.delegate = self
        placeTypePicker.dataSource = self
        placeTypePicker.selectRow(PlaceType.allCases.count / 2, inComponent: 0, animated: true)
    }

    
    // MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoLibraryIcon = #imageLiteral(resourceName: "gallery")
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            
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
    
    
    
    func saveNewPlace() {
        
        var image: UIImage?
        
        if isImageChanged {
            image = placeImage.image
        } else {
            image = #imageLiteral(resourceName: "Default place image")
        }
        
        let newPlace = Place(name: placeNameField.text!,
                             location: placeLocationField.text!,
                             type: selectedPlaceType,
                             imageData: image?.pngData())
        
        StorageManager.saveObject(newPlace)
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}


// MARK: Text field delegate

extension NewPlaceTableViewController: UITextFieldDelegate {
    //Hide keyboard after "Done" pressing
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged () {
        if placeNameField.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
}


// MARK: Work with image

extension NewPlaceTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        guard UIImagePickerController.isSourceTypeAvailable(source) else { return }
            
        let imagePicker = UIImagePickerController()
            
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        present(imagePicker, animated: true)
            
        imagePicker.delegate = self
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        
        isImageChanged = true
        
        dismiss(animated: true)
    }
}


// MARK: Work with picker view

extension NewPlaceTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PlaceType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        selectedPlaceType = PlaceType.allCases[row]
          selectedPlaceType = PlaceType.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return PlaceType.allCases[row].rawValue
    }
    
}
