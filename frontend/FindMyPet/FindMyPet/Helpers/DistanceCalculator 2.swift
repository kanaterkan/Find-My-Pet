//
//  DistanceCalculator.swift
//  FindMyPet
//
//  Created by Erkan Kanat on 29.11.23.
//

import Foundation
import CoreLocation


class DistanceCalculator: ObservableObject {
    private let locationManager = LocationManager.shared

    @Published var nearbyReports: [ReportDetail] = []
    @Published var distantReports: [ReportDetail] = []

    init() {
        // Initialisierungscode falls benötigt
    }

    func calculateDistances(reports: [ReportDetail]) {
        // Hier die gewünschten Koordinaten für den Test eingeben
        let testLatitude = 51.3704
        let testLongitude = 6.1729
        let testLocation: CLLocation? = CLLocation(latitude: testLatitude, longitude: testLongitude)

        guard let userLocation = locationManager.currentLocation ?? testLocation else {
            print("User location is nil.")
            return
        }

        nearbyReports.removeAll()
        distantReports.removeAll()

        for report in reports {
            if let reportCoordinates = convertStringToCoordinates(report.location) {
                let distance = calculateDistance(from: userLocation, to: CLLocation(latitude: reportCoordinates.latitude, longitude: reportCoordinates.longitude))

              
                print("Distance to \(report.petName): \(distance) km")

                
                if distance < 100.0 {
                    nearbyReports.append(report)
                } else if distance > 100.0 {
                    distantReports.append(report)
                }
            }
        }

        // Drucke den Inhalt der Listen für das Debugging
        print("Nearby Reports:")
        nearbyReports.forEach { report in
            print("- \(report.petName)")
        }

        print("\nDistant Reports:")
        distantReports.forEach { report in
            print("- \(report.petName)")
        }
    }

    private func calculateDistance(from source: CLLocation, to destination: CLLocation) -> Double {
        return source.distance(from: destination) / 1000.0  // Entfernung in Kilometern
    }

    private func convertStringToCoordinates(_ locationString: String) -> CLLocationCoordinate2D? {
        let cleanedString = locationString.replacingOccurrences(of: "° N", with: "").replacingOccurrences(of: "° E", with: "")
        let components = cleanedString.components(separatedBy: ",")

        guard components.count == 2,
            let latitude = Double(components[0]),
            let longitude = Double(components[1]) else {
                return nil
        }

        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
