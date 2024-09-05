import SwiftUI
import MapKit
import CoreLocation
struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var selectedResult: MKMapItem?
    @State private var route: MKRoute?
    var petReports: [ReportDetail]
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Map(selection: $selectedResult) {
                // Iterate over petReports to create markers
                ForEach(petReports, id: \.id) { report in
                    if let coordinates = convertStringToCoordinates(report.location) {
                        Marker("\(report.petName) (\(report.petType))", coordinate: coordinates)
                    }
                }
                
                UserAnnotation()
                
                // Show the route if it's available
                if let route = route {
                    MapPolyline(route)
                        .stroke(.blue, lineWidth: 5)
                }
            }
            .mapStyle(.standard(elevation: .realistic))
        }
        //.navigationBarItems(leading: backButton)
    }

    //var backButton: some View {
      //  Button(action: {
      //      presentationMode.wrappedValue.dismiss()
      //  }) {
       //     Image(systemName: "arrow.left")
      //          .foregroundColor(.blue)
       //         .padding(6)
       //         .background(Color.clear)
       //         .cornerRadius(10)
       // }
    //}

    private func convertStringToCoordinates(_ locationString: String) -> CLLocationCoordinate2D? {
        let components = locationString.components(separatedBy: ",")
        guard components.count == 2,
              let latitude = Double(components[0]),
              let longitude = Double(components[1]) else {
            return nil
        }

        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
                                            
                                        


//    func getDirections() {
//        guard let selectedResult = selectedResult, let currentLocation = locationManager.currentLocation else { return }
//
//        let request = MKDirections.Request()
//        request.source = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation.coordinate))
//        request.destination = selectedResult
//
//        Task {
//            let directions = MKDirections(request: request)
//            let response = try? await directions.calculate()
//            route = response?.routes.first
//        }
//    }

                                            
                                            
                                            // Show the route if it's available
                            //                if let route = route {
                            //                    MapPolyline(route)
                            //                        .stroke(.blue, lineWidth: 5)
                            //                }
                                            
                                            
                                            

                                            // Uncomment for automatic route calculation
                                    //        .onChange(of: selectedResult) { _ in
                                    //            getDirections()
                                    //        }
                                    //        .onAppear {
                                    //            self.selectedResult = MKMapItem(placemark: MKPlacemark(coordinate: self.destinationCoordinates))
                                    //            locationManager.onLocationUpdate = {
                                    //                self.getDirections()
                                    //            }
                                    //            locationManager.requestLocation()
                                    //        }
                                    //        .navigationBarItems(leading: Button(action: {
                                    //            self.presentationMode.wrappedValue.dismiss()
                                    //        }) {
                                    //            Image(systemName: "arrow.left")
                                    //                .foregroundColor(.blue)
                                    //                .padding(6)
                                    //                .background(Color.clear)
                                    //                .cornerRadius(10)
                                    //        })
                                    //        .navigationBarTitleDisplayMode(.inline)
                                        
