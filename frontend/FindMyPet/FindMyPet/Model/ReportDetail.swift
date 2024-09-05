//
//  ReportDetail.swift
//  FindMyPet
//
//  Created by Feyza Serin on 15.11.23.
//

import Foundation


struct ReportDetail: Codable, Hashable, Identifiable{
    var id: Int?
    var petName: String
    var petType: String
    var petBreed: String
    var petDescription: String
    var petGender: Bool
    var dateReported: Int
    var petPicture: String
    var isFound: Bool
    var location: String
    var userId: Int
}
    

    
    

    //var id: Int?
    //var petName: String
    //var petType: String
    //var petBreed: String
    //var petDescription: String
    //var petGender: Bool
  //  var dateReported = Date()
   //)/ var isFound: Bool
  //  var userId: Int
    
  //  private var imageName: String
  //  var image: Image {
    //    Image(imageName)
   // }
    
    //private var coordinates: Coordinates
   // var locationCoordinate: CLLocationCoordinate2D {
    //    CLLocationCoordinate2D(
    //        latitude: coordinates.latitude, longitude: coordinates.longitude)
    //}
    //struct Coordinates: Hashable, Codable {
     //   var latitude: Double
    //    var longitude: Double
   // }
    


