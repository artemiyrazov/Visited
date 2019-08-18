import RealmSwift

enum PlaceType: String, CaseIterable {
    case Cafe
    case Bar
    case Restaurant
    case Park
    case UrbanSpace = "Urban Space"
    case TransportNode = "Transport Node"
    case Other
}


class Place: Object {
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String? //CHANGE
    @objc dynamic var imageData: Data?
    
    convenience init (name: String, location: String?, type: String?, imageData: Data?) {
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
    }
    
}






