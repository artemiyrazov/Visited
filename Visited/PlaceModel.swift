import RealmSwift

enum PlaceType: String, CaseIterable {
    case Cafe
    case Bar
    case Restaurant
    case Park
    case Museum
    case Cinema
    case UrbanSpace = "Urban Space"
    case TransportNode = "Transport Node"
    case Other
    
    static func index(of aPlace: PlaceType) -> Int {
        let elements = [PlaceType.Cafe, .Bar, .Restaurant, .Park, .Museum, .Cinema, .UrbanSpace,
                        .TransportNode, .Other]
        
        return elements.firstIndex(of: aPlace)!
    }
}


class Place: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var date = Date()
    @objc dynamic var rating = 0.0
    
    @objc dynamic private var privateType: String = PlaceType.Other.rawValue
    var type: PlaceType {
        
        get {
            return PlaceType(rawValue: privateType)!
        }
        
        set {
            privateType = newValue.rawValue
        }
    }
    
    
    
    convenience init (name: String,
                      location: String?,
                      type: PlaceType,
                      imageData: Data?,
                      rating: Double) {
        
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
        self.rating = rating
    }
    
}






