import SwiftUI
import MapKit

struct PetLocation: View {
    @State private var addressString = "" // Hold the address string
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.3704, longitude: 6.1724),
        span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06)
    )
    @Environment(\.presentationMode) var presentationMode

    let venloCoordinate = CLLocationCoordinate2D(latitude: 51.3704, longitude: 6.1724)
    
    var body: some View {
        NavigationView {
            Map(coordinateRegion: $region, annotationItems: [VenloAnnotation(id: UUID(), coordinate: venloCoordinate)]) { annotation in
                MapAnnotation(coordinate: annotation.coordinate) {
                    VStack {
                        Text(addressString)
                            .font(.caption)
                            .foregroundColor(.black)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 0.5)
                            )
                        
                        Circle()
                            .fill(Color.red)
                            .frame(width: 20, height: 20)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear(perform: lookupAddress)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.blue)
                    .padding(6)
                    .background(Color.black.opacity(0.6))
//                    .clipShape(Circle())
                    .cornerRadius(10)
            })
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func lookupAddress() {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: venloCoordinate.latitude, longitude: venloCoordinate.longitude)) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed: \(error)")
                self.addressString = "Unknown"
            } else if let placemarks = placemarks, let placemark = placemarks.first {
                self.addressString = [placemark.thoroughfare, placemark.subThoroughfare, placemark.locality, placemark.administrativeArea, placemark.postalCode, placemark.country]
                    .compactMap { $0 }
                    .joined(separator: ", ")
            }
        }
    }
}

struct VenloAnnotation: Identifiable {
    let id: UUID
    let coordinate: CLLocationCoordinate2D
}

struct PetLocation_Previews: PreviewProvider {
    static var previews: some View {
        PetLocation()
    }
}
