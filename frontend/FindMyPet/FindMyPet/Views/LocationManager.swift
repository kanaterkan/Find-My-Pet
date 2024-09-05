import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation? //observe changes in current location
    var onLocationUpdate: (() -> Void)? //optional closure (gets called when location is updated)
    static let shared = LocationManager()

    override init() {
        super.init()
        locationManager.delegate = self //receive location updates
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        //request location services permissions from user
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Update current location with first location in array
        currentLocation = locations.first
        onLocationUpdate?()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle failure to get a user's location
    }
}
