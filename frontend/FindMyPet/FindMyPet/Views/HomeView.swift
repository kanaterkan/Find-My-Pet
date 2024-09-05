import SwiftUI
import CoreLocation



struct HomeView: View {
    @State private var isMapViewExpanded = false
    @State private var isMapViewManuallyExpanded = false
    @State private var selectedDistance: Int?
    @State private var petReports: [ReportDetail] = []
    @StateObject private var distanceCalculator = DistanceCalculator()
    @State private var firstName = ""
    var receivedToken:String?
    
    @StateObject private var locationManager = LocationManager.shared
  var user: UserDetail?
    


 
    var body: some View {
        NavigationView {
                    List {
                        Text("Lost Pets Near You: ")
                            .font(.headline)
                            .foregroundColor(.purple)
                        
                        NavigationLink(
                            destination: MapView(petReports: petReports)
                                .navigationBarHidden(false)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    isMapViewManuallyExpanded.toggle()
                                },
                            isActive: $isMapViewExpanded,
                            label: {
                                MapView(petReports: petReports)
                                    .frame(height: 200)
                                    .onTapGesture {
                                        isMapViewExpanded.toggle()
                                    }
                            }
                        )
                        
                        
                        .listRowInsets(EdgeInsets())
                        
                        //ForEach(petReports) { report in
                           // Text("Pet Name: \(report.petName)")
                            // ... Mehr Informationen zu jedem Pet-Report
                       // }
                        
                        
                        CategoryRow(user: user, receivedToken: receivedToken!)
                       
                        
                    }
                    .onAppear {
                        Task {
                            await loadUserData()
                            await locationManager.requestLocation()
                                if let userLocation = locationManager.currentLocation {
                                    
                                   
                                    
                                    await processPetReports(userLocation: userLocation)
                                } else {
                                    // Handle the case when the location is not available
                                    print("Location is not available")
                                }
                            }
                        
                    }
                    .environmentObject(distanceCalculator)
                    .navigationTitle("Welcome, \(firstName)")
                    .navigationBarBackButtonHidden(true)
                }
        
         
       
            }
    
    var backButton: some View {
        Button(action: {
            isMapViewExpanded = false
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.blue)
                .imageScale(.large)
        }
    }
    
    
    func processPetReports(userLocation: CLLocation) async {
        do {
            try await loadPetReports { petReports in
                self.petReports = petReports
                print("Loaded Pet Reports:")
                petReports.forEach { report in
                    print("- \(report.petName)")
                }

                self.distanceCalculator.calculateDistances(reports: petReports, userlocation: userLocation)
                print("Calculating distances...")
            }
        } catch {
            // Handle errors appropriately
            print("Error processing pet reports: \(error)")
        }
    }
    
     func loadUserData() async{
        let urlString = "\(AppConfig.baseURL)/whoAmI"
         do{
             let userD = try await whoAmI(urlString: urlString, token: receivedToken!)
             
             firstName = userD.firstname
             
             
                    // Setze die empfangenen Daten in die
                    print("Userdetail: ", userD)
        }catch{
            print("UI-error: ",error)
        }
        print("Userdata loaded succesful ")
    }
    
  
   
}

