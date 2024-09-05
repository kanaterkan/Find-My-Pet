import SwiftUI

struct ContentView: View {
    @State private var loggedIn = true
    var receivedToken: String?
    
    var user: UserDetail?
    
    // Declare storedDeviceToken using AppStorage
    @AppStorage("deviceToken") var storedDeviceToken: String?
    
    var body: some View {
        
        if let receivedToken = receivedToken {
            TabView(selection: $loggedIn) {
                HomeView(receivedToken: receivedToken, user: user )
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(0)
                
                
                PetReportView(receivedToken: receivedToken)
                    .tabItem {
                        Image(systemName: "plus")
                        Text("Report")
                    }
                    .tag(1)
                
                ReportList(receivedToken: receivedToken, user: user)
                    .tabItem {
                        Image(systemName: "list.bullet.rectangle")
                        Text("MyReports")
                    }
                    .tag(2)
                
                ProfileView(receivedToken: receivedToken)
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                    .tag(3)
            }
            .accentColor(.purple)
            .navigationBarHidden(true) // Verstecke die Navigationsleiste in der gesamten TabView
            .onAppear {
                print("ContentView appeared")
                print("User ID from LoginView: \(user?.id.map(String.init) ?? "nil")")
                // When the view appears, check for the stored device token and user ID
                if let storedDeviceToken = storedDeviceToken,
                   let userID = user?.id { // Using the user ID passed from the LoginView
                    print("Stored Device Token: \(storedDeviceToken), UserID: \(userID)")
                    Task {
                        await DeviceTokenRequest.sendDeviceTokenToServer(token: storedDeviceToken, userID: String(userID))
                    }
                }
            }
        } else {
            WelcomeScreen()
        }
    }
    
    
    
    func loadUserData() async{
        let urlString = "\(AppConfig.baseURL)/whoAmI"
        do{
            
            let userDetail = try await whoAmI(urlString: urlString, token: receivedToken!)
            
            // Setze die empfangenen Daten in die @State-Variablen
            
            print("Userdetail: ", userDetail)
        }catch{
            print("UI-error: ",error)
        }
        print("Userdata loaded succesful ")
    }
    
    
    
}
